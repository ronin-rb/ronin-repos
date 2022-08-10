require 'spec_helper'
require 'ronin/repos/class_dir'

describe Ronin::Repos::ClassDir do
  let(:fixtures_dir) { File.expand_path(File.join(__dir__,'fixtures')) }

  describe ".repo_class_dir" do
    context "when a repo_class_dir has been defined" do
      module TestClassDir
        module WithReposClassDirSet
          include Ronin::Repos::ClassDir

          repo_class_dir "dir"
        end
      end

      subject { TestClassDir::WithReposClassDirSet }

      it "must return the previously set .repo_class_dir" do
        expect(subject.repo_class_dir).to eq("dir")
      end
    end

    context "but when no repo_class_dir has been defined" do
      module TestReposDir
        module WithoutReposDirSet
          include Ronin::Repos::ClassDir
        end
      end

      subject { TestReposDir::WithoutReposDirSet }

      it do
        expect {
          subject.repo_class_dir
        }.to raise_error(NotImplementedError,"#{subject} did not define a repo_class_dir")
      end
    end
  end

  module TestReposDir
    module ExampleNamespace
      include Ronin::Core::ClassRegistry
      include Ronin::Repos::ClassDir

      class_dir "#{__dir__}/fixtures/class_dir"
      repo_class_dir 'dir'
    end
  end

  subject { TestReposDir::ExampleNamespace }

  describe ".list_files" do
    before do
      expect(Ronin::Repos).to receive(:list_files).and_return(
        Set.new(
          %w[
            file1.rb
            file2.rb
          ]
        )
      )
    end

    it "must list the modules in the .class_dir and in all .repo_class_dir" do
      expect(subject.list_files).to eq(
        %w[
          file1
          file2
          only_in_class_dir
        ]
      )
    end
  end

  describe ".path_for" do
    context "when the module name exists in the .class_dir" do
      it "must return the path to the module file in .class_dir" do
        expect(subject.path_for('only_in_class_dir')).to eq(
          File.join(subject.class_dir,'only_in_class_dir.rb')
        )
      end
    end

    context "when the module name exists in one of the installed repos" do
      it "must call Repos.find_file with the .repo_class_dir and module file name" do
        expect(Ronin::Repos).to receive(:find_file).with(
          File.join(subject.repo_class_dir,'file.rb')
        ).and_return("/path/to/#{subject.repo_class_dir}/file.rb")

        expect(subject.path_for('file')).to eq(
          "/path/to/#{subject.repo_class_dir}/file.rb"
        )
      end
    end
  end
end
