require 'spec_helper'
require 'ronin/repos/cache_dir'

describe Ronin::Repos::CacheDir do
  let(:fixtures_dir) { File.expand_path(File.join(__dir__,'fixtures')) }
  let(:cache_dir)    { File.join(fixtures_dir,'cache') }

  describe "PATH" do
    subject { described_class::PATH }

    it "must default to ~/.cache/ronin-repos" do
      expect(subject).to eq(File.join(ENV['HOME'],'.cache','ronin-repos'))
    end
  end

  subject { described_class.new(cache_dir) }

  describe "#initialize" do
    context "when no arguments are given" do
      subject { described_class.new }

      it "must set #path to PATH" do
        expect(subject.path).to eq(described_class::PATH)
      end
    end

    context "when given a path argument" do
      subject { described_class.new(cache_dir) }

      it "must set #path" do
        expect(subject.path).to eq(cache_dir)
      end
    end
  end

  describe "#[]" do
    context "when a repository with the given name exists in the cache dir" do
      let(:name) { 'repo2' }

      it "must return a Repository object with the matching name" do
        repo = subject[name]

        expect(repo).to be_kind_of(Repository)
        expect(repo.name).to eq(name)
      end
    end

    context "when given an unknown repository name" do
      let(:name) { 'does_not_exist' }

      it do
        expect {
          subject[name]
        }.to raise_error(RepositoryNotFound,"repository not found: #{name.inspect}")
      end
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield each Repository object" do
        yielded_repos = []

        subject.each do |repo|
          yielded_repos << repo
        end

        expect(yielded_repos.length).to eq(2)
        expect(yielded_repos[0]).to be_kind_of(Repository)
        expect(yielded_repos[0].name).to eq("repo1")

        expect(yielded_repos[1]).to be_kind_of(Repository)
        expect(yielded_repos[1].name).to eq("repo2")
      end
    end

    context "when no block is given" do
      it "must return an Enumerator object" do
        yielded_repos = subject.each.to_a

        expect(yielded_repos.length).to eq(2)
        expect(yielded_repos[0]).to be_kind_of(Repository)
        expect(yielded_repos[0].name).to eq("repo1")

        expect(yielded_repos[1]).to be_kind_of(Repository)
        expect(yielded_repos[1].name).to eq("repo2")
      end
    end
  end

  describe "#install" do
    let(:name) { 'new_repo' }
    let(:uri)  { "https://github.com/example/#{name}.git" }
    let(:path) { File.join(cache_dir,name) }

    let(:new_repo) { double('Repository') }

    it "must `git clone` the given URI into the cache directory" do
      expect(Repository).to receive(:system).with(
        'git', 'clone', uri, path
      ).and_return(true)

      expect(Repository).to receive(:new).and_return(new_repo)

      expect(subject.install(uri)).to be(new_repo)
    end

    context "when a custom name is given" do
      let(:custom_name) { 'custom-repo' }
      let(:path)        { File.join(cache_dir,custom_name) }

      it "must use the custom name instead of deriving the repository's name" do
        expect(Repository).to receive(:system).with(
          'git', 'clone', uri, path
        ).and_return(true)

        expect(Repository).to receive(:new).and_return(new_repo)

        expect(subject.install(uri,custom_name)).to be(new_repo)
      end
    end
  end

  describe "#update" do
    it "must call #update on each repository in the cache directory"

    context "but system() returns nil" do
      it do
        expect_any_instance_of(Repository).to receive(:system).and_return(nil)

        expect {
          subject.update
        }.to raise_error(CommandNotInstalled,"git is not installed")
      end
    end
  end

  describe "#remove" do
    let(:name) { 'repo2' }

    it "must call #delete on the Repository" do
      expect_any_instance_of(Repository).to receive(:delete)

      subject.remove(name)
    end

    context "when given an unknown repository name" do
      let(:name) { 'does-not-exist' }

      it do
        expect {
          subject.remove(name)
        }.to raise_error(RepositoryNotFound,"repository not found: #{name.inspect}")
      end
    end
  end

  describe "#purge" do
    it "must call #delete on every repository in the cache directory" do
      expect(FileUtils).to receive(:rm_rf).with(File.join(cache_dir,'repo1'))
      expect(FileUtils).to receive(:rm_rf).with(File.join(cache_dir,'repo2'))

      subject.purge
    end
  end

  describe "#find_file" do
    let(:relative_path) { 'only-exists-in-repo2.txt' }

    it "must return the first file that matches the given relative path" do
      expect(subject.find_file(relative_path)).to eq(
        File.join(cache_dir,'repo2',relative_path)
      )
    end

    context "when the relative path does not exist within any repository" do
      let(:relative_path) { 'does/not/exist.txt' }

      it "must return nil" do
        expect(subject.find_file(relative_path)).to be(nil)
      end
    end
  end

  describe "#glob" do
    context "when the pattern matches files within all repositories" do
      let(:pattern) { 'dir/*.txt' }

      it "must return the absolute path to the file" do
        expect(subject.glob(pattern)).to eq(
          Dir[File.join(cache_dir,'*',pattern)]
        )
      end

      context "when a block is given" do
        it "must yield the matching absolute paths" do
          expect { |b|
            subject.glob(pattern,&b)
          }.to yield_successive_args(
            *Dir[File.join(cache_dir,'*',pattern)]
          )
        end
      end
    end

    context "when the relative path does not exist within any repository" do
      let(:pattern) { 'does/not/exist/*.txt' }

      it "must return []" do
        expect(subject.glob(pattern)).to eq([])
      end

      context "when a block is given" do
        it "must not yield" do
          expect { |b|
            subject.glob(pattern,&b)
          }.to_not yield_control
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the cache directory path" do
      expect(subject.to_s).to eq(cache_dir)
    end
  end
end
