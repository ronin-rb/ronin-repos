require 'spec_helper'
require 'ronin/repos/cli/commands/new'
require_relative 'man_page_example'

require 'tmpdir'

describe Ronin::Repos::CLI::Commands::New do
  include_examples "man_page"

  describe "#run" do
    before(:all) do
      @root = Dir.mktmpdir('test-ronin-repos-new')
      @name = 'new-repo'
      @path = File.join(@root,@name)

      @git_name    = `git config --global user.name`
      @git_email   = `git config --global user.email`
      @github_user = Ronin::Core::Git.github_user || ENV['USER']

      if @git_name.empty?
        # ensure that we set the git author name and email in the CI
        @git_name    = 'Test User'
        @git_email   = 'test@example.com'

        system('git','config','--global','user.name',@git_name)
        system('git','config','--global','user.email',@git_email)
      end

      described_class.main(@path)
    end

    it "must create the repo directory" do
      expect(File.directory?(@path)).to be(true)
    end

    it "must create a git repository within the directory" do
      expect(File.directory?(File.join(@path,'.git'))).to be(true)
    end

    it "must make an initial git commit" do
      expect(`git -C "#{@path}" log --pretty=oneline`).to match(
        /[0-9a-f]{40} Initial commit./
      )
    end

    it "must create a README.md file within the directory" do
      readme = File.join(@path,'README.md')

      expect(File.file?(readme)).to be(true)
      expect(File.read(readme)).to eq(
        <<~README
          # #{@name}

          ## Install

          This git repository can be installed by the [ronin-repos] command:

          ```shell
          ronin-repos install https://github.com/#{@github_user}/#{@name}.git
          ```

          [ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
        README
      )
    end
  end
end
