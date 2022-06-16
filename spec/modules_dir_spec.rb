require 'spec_helper'
require 'ronin/repos/modules_dir'

describe Ronin::Repos::ModulesDir do
  describe ".repo_modules_dir" do
    context "when a repo_modules_dir has been defined" do
      module TestModulesDir
        module WithReposModulesDirSet
          include Ronin::Repos::ModulesDir

          repo_modules_dir "dir"
        end
      end

      subject { TestModulesDir::WithReposModulesDirSet }

      it "must return the previously set .repo_modules_dir" do
        expect(subject.repo_modules_dir).to eq("dir")
      end
    end

    context "but when no repo_modules_dir has been defined" do
      module TestReposDir
        module WithoutReposDirSet
          include Ronin::Repos::ModulesDir
        end
      end

      subject { TestReposDir::WithoutReposDirSet }

      it do
        expect {
          subject.repo_modules_dir
        }.to raise_error(NotImplementedError,"#{subject} did not define a repo_modules_dir")
      end
    end
  end

  module TestReposDir
    module ExampleNamespace
      include Ronin::Core::ModuleRegistry
      include Ronin::Repos::ModulesDir

      modules_dir "#{__dir__}/fixtures/modules_dir"
      repo_modules_dir 'dir'
    end
  end

  subject { TestReposDir::ExampleNamespace }

  describe ".list_modules" do
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

    it "must list the modules in the .modules_dir and in all .repo_modules_dir" do
      expect(subject.list_modules).to eq(
        %w[
          file1
          file2
          only_in_modules_dir
        ]
      )
    end
  end

  describe ".find_file" do
    context "when the module name exists in the .modules_dir" do
      it "must return the path to the module file in .modules_dir" do
        expect(subject.find_module('only_in_modules_dir')).to eq(
          File.join(subject.modules_dir,'only_in_modules_dir.rb')
        )
      end
    end

    context "when the module name exists in one of the installed repos" do
      it "must call Repos.find_file with the .repo_modules_dir and module file name" do
        expect(Ronin::Repos).to receive(:find_file).with(
          File.join(subject.repo_modules_dir,'file.rb')
        )

        subject.find_module('file')
      end
    end
  end
end
