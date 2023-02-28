require 'spec_helper'
require 'ronin/repos/repository'

describe Ronin::Repos::Repository do
  let(:fixtures_dir) { File.expand_path(File.join(__dir__,'fixtures')) }

  let(:name) { 'repo1' }
  let(:path) { File.join(fixtures_dir,'cache',name) }

  subject { described_class.new(path) }

  describe "#initialize" do
    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    it "must set #name based on #path" do
      expect(subject.name).to eq(File.basename(path))
    end

    context "when the path does not exist" do
      let(:path) { '/path/does/not/exist' }

      it do
        expect {
          described_class.new(path)
        }.to raise_error(Ronin::Repos::RepositoryNotFound,"repository does not exist: #{path.inspect}")
      end
    end

    context "when the path is not a directory" do
      let(:path) { __FILE__ }

      it do
        expect {
          described_class.new(path)
        }.to raise_error(Ronin::Repos::RepositoryNotFound,"path is not a directory: #{path.inspect}")
      end
    end
  end

  describe ".clone" do
    let(:uri)  { 'https://github.com/example/repo.git' }

    subject { described_class }

    it "must call `git clone` the URI to the given path and return a Repository" do
      expect(subject).to receive(:system).with(
        'git', 'clone', uri, path
      ).and_return(true)

      repo = subject.clone(uri,path)

      expect(repo).to be_kind_of(described_class)
      expect(repo.path).to eq(path)
    end

    context "when a depth: keyword argument is given" do
      let(:depth) { 1 }

      it "must `git clone --depth` with the given depth and URI to the given path)" do
        expect(subject).to receive(:system).with(
          'git', 'clone', '--depth', depth.to_s, uri, path
        ).and_return(true)

        subject.clone(uri,path, depth: depth)
      end
    end

    context "when system() returns nil" do
      it do
        allow(subject).to receive(:system).and_return(nil)

        expect {
          subject.clone(uri,path)
        }.to raise_error(Ronin::Repos::CommandNotInstalled,"git is not installed")
      end
    end

    context "when system() returns false" do
      it do
        allow(subject).to receive(:system).and_return(false)

        expect {
          subject.clone(uri,path)
        }.to raise_error(Ronin::Repos::CommandFailed,"command failed: git clone #{uri} #{path}")
      end
    end
  end

  describe ".install" do
    let(:uri)  { 'https://github.com/example/repo.git' }

    subject { described_class }

    it "must `git clone` the URI and the given path and return a Repository" do
      expect(subject).to receive(:system).with(
        'git', 'clone', uri, path
      ).and_return(true)

      repo = subject.install(uri,path)

      expect(repo).to be_kind_of(described_class)
      expect(repo.path).to eq(path)
    end

    context "when the branch: keyword argument is given" do
      let(:branch) { 'foo' }

      it "must `git clone` the URI to the given path and then `git checkout` the branch)" do
        expect(subject).to receive(:system).with(
          'git', 'clone', uri, path
        ).and_return(true)

        expect_any_instance_of(described_class).to receive(:system).with(
          'git', 'checkout', branch
        ).and_return(true)

        subject.install(uri,path, branch: branch)
      end
    end

    context "when the tag: keyword argument is given" do
      let(:tag) { 'v1.0.0' }

      it "must `git clone` the URI to the given path and then `git checkout` the tag" do
        expect(subject).to receive(:system).with(
          'git', 'clone', uri, path
        ).and_return(true)

        expect_any_instance_of(described_class).to receive(:system).with(
          'git', 'checkout', tag
        ).and_return(true)

        subject.install(uri,path, tag: tag)
      end
    end
  end

  describe "#pull" do
    it "must `git pull` from 'origin'" do
      expect(subject).to receive(:system).with(
        'git', 'pull', 'origin'
      ).and_return(true)

      subject.pull
    end

    context "when the remote: keyword argument is given" do
      let(:remote) { :backup }

      it "must `git pull` from the given remote" do
        expect(subject).to receive(:system).with(
          'git', 'pull', remote.to_s
        ).and_return(true)

        subject.pull(remote: remote)
      end
    end

    context "when the branch: keyword argument is given" do
      let(:branch) { 'foo' }

      it "must `git pull` from 'origin' and the given branch" do
        expect(subject).to receive(:system).with(
          'git', 'pull', 'origin', branch
        ).and_return(true)

        subject.pull(branch: branch)
      end
    end

    context "when the `tags: true` is given" do
      it "must `git pull` from 'origin' and pull down any tags" do
        expect(subject).to receive(:system).with(
          'git', 'pull', '--tags', 'origin'
        ).and_return(true)

        subject.pull(tags: true)
      end
    end

    context "when system() returns nil" do
      it do
        allow(subject).to receive(:system).and_return(nil)

        expect {
          subject.pull
        }.to raise_error(Ronin::Repos::CommandNotInstalled,"git is not installed")
      end
    end

    context "when system() returns false" do
      it do
        allow(subject).to receive(:system).and_return(false)

        expect {
          subject.pull
        }.to raise_error(Ronin::Repos::CommandFailed,"command failed: git pull origin")
      end
    end
  end

  describe "#checkout" do
    let(:branch) { 'foo' }

    it "must `git checkout` the given branch" do
      expect(subject).to receive(:system).with(
        'git', 'checkout', branch
      ).and_return(true)

      subject.checkout(branch)
    end

    context "when system() returns nil" do
      it do
        allow(subject).to receive(:system).and_return(nil)

        expect {
          subject.checkout(branch)
        }.to raise_error(Ronin::Repos::CommandNotInstalled,"git is not installed")
      end
    end

    context "when system() returns false" do
      it do
        allow(subject).to receive(:system).and_return(false)

        expect {
          subject.checkout(branch)
        }.to raise_error(Ronin::Repos::CommandFailed,"command failed: git checkout #{branch}")
      end
    end
  end

  describe "#update" do
    it "must `git pull` from 'origin' and pull down any tags" do
      expect(subject).to receive(:system).with(
        'git', 'pull', '--tags', 'origin'
      ).and_return(true)

      subject.update
    end

    context "when the branch: keyword argument is given" do
      let(:branch) { 'foo' }

      it "must `git pull` from 'origin' and the given branch and then `git checkout` the branch" do
        expect(subject).to receive(:system).with(
          'git', 'pull', 'origin', branch
        ).and_return(true)

        expect(subject).to receive(:system).with(
          'git', 'checkout', branch
        ).and_return(true)

        subject.update(branch: branch)
      end
    end

    context "when the tag: keyword argument is given" do
      let(:tag) { 'v1.0.0' }

      it "must `git pull --tags` from 'origin' and then `git checkout` the given tag" do
        expect(subject).to receive(:system).with(
          'git', 'pull', '--tags', 'origin'
        ).and_return(true)

        expect(subject).to receive(:system).with(
          'git', 'checkout', tag
        ).and_return(true)

        subject.update(tag: tag)
      end
    end
  end

  describe "#delete" do
    it "must call FileUtils.rm_rf on the path" do
      expect(FileUtils).to receive(:rm_rf).with(path)

      subject.delete
    end
  end

  describe "#join" do
    let(:relative_path) { 'file1.txt' }

    it "must return the absolute path with respect to the repository" do
      expect(subject.join(relative_path)).to eq(
        File.join(path,relative_path)
      )
    end
  end

  describe "#has_file?" do
    context "when the repository contains the file" do
      let(:relative_path) { 'file1.txt' }

      it "must return the absolute path to the file" do
        expect(subject.has_file?(relative_path)).to be(true)
      end
    end

    context "when the relative path does not exist within the repository" do
      let(:relative_path) { 'does/not/exist.txt' }

      it "must return false" do
        expect(subject.has_file?(relative_path)).to be(false)
      end
    end
  end

  describe "#has_directory?" do
    context "when the repository contains the directory" do
      let(:relative_path) { 'dir' }

      it "must return the absolute path to the directory" do
        expect(subject.has_directory?(relative_path)).to be(true)
      end
    end

    context "when the relative path does not exist within the repository" do
      let(:relative_path) { 'does/not/exist' }

      it "must return false" do
        expect(subject.has_directory?(relative_path)).to be(false)
      end
    end
  end

  describe "#find_file" do
    context "when the relative path exists within the repository" do
      let(:relative_path) { 'file1.txt' }

      it "must return the absolute path to the file" do
        expect(subject.find_file(relative_path)).to eq(
          File.join(path,relative_path)
        )
      end
    end

    context "when the relative path does not exist within the repository" do
      let(:relative_path) { 'does/not/exist.txt' }

      it "must return nil" do
        expect(subject.find_file(relative_path)).to be(nil)
      end
    end
  end

  describe "#glob" do
    context "when the pattern matches files within the repository" do
      let(:pattern) { 'dir/*.txt' }

      it "must return the absolute path to the file" do
        expect(subject.glob(pattern)).to eq(
          Dir[File.join(path,pattern)]
        )
      end

      context "when a block is given" do
        it "must yield the matching absolute paths" do
          expect { |b|
            subject.glob(pattern,&b)
          }.to yield_successive_args(
            *Dir[File.join(path,pattern)]
          )
        end
      end
    end

    context "when the relative path does not exist within the repository" do
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

  describe "#list_files" do
    context "when given no arguments" do
      it "must list every file within the repository's directory" do
        expect(subject.list_files).to eq(
          %w[
            dir/file1.txt
            file1.txt
            file2.txt
          ]
        )
      end
    end

    context "when given a glob pattern" do
      it "must list only the files that match the glob pattern" do
        expect(subject.list_files('dir/*.txt')).to eq(%w[dir/file1.txt])
      end
    end
  end

  describe "#to_s" do
    it "must return the repository name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
