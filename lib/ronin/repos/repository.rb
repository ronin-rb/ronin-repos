#
# Copyright (c) 2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-repos.
#
# ronin-repos is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-repos is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-repos.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/repos/exceptions'

require 'fileutils'

module Ronin
  module Repos
    #
    # Represents an installed repository.
    #
    # @api private
    #
    class Repository

      # The path to the repository's directory.
      #
      # @return [String]
      attr_reader :path

      # The name of the repository.
      #
      # @return [String]
      attr_reader :name

      #
      # Initializes the repository.
      #
      # @param [String] path
      #   The path to the repository.
      #
      # @raise [RepositoryNotFound]
      #   The path does not exist or does not point to a directory.
      #
      def initialize(path)
        @path = File.expand_path(path)

        unless File.exist?(@path)
          raise(RepositoryNotFound,"repository does not exist: #{@path.inspect}")
        end

        unless File.directory?(@path)
          raise(RepositoryNotFound,"path is not a directory: #{@path.inspect}")
        end

        @name = File.basename(@path)
      end

      #
      # Clones a repository.
      #
      # @param [String, URI::HTTPS] uri
      #   The `https://` or `git@HOST:PATH` SSH URI 
      #
      # @param [String] path
      #   The path to where the repository will be cloned to.
      #
      # @param [Integer, nil] depth
      #   The number of commits to clone.
      #
      # @return [Repository]
      #   The newly cloned repository.
      #
      # @raise [CommandFailed]
      #   The `git` command failed.
      #
      # @raise [CommandNotFailed]
      #   The `git` command is not installed.
      #
      def self.clone(uri,path, depth: nil)
        path = path.to_s
        args = []

        if depth
          args << '--depth' << depth.to_s
        end

        args << uri.to_s
        args << path.to_s

        case system('git','clone',*args)
        when nil
          raise(CommandNotInstalled,"git is not installed")
        when false
          raise(CommandFailed,"command failed: git clone #{args.join(' ')}")
        end

        return new(path)
      end

      #
      # Clones and installs a repository from the URI and to the destination
      # path.
      #
      # @param [String, URI::HTTPS] uri
      #   The `https://` or `git@HOST:PATH` SSH URI 
      #
      # @param [String] path
      #   The path to where the repository will be cloned to.
      #
      # @param [String, nil] branch
      #   The git branch to pull.
      #
      # @param [Boolean] tag
      #   Controls whether to pull git tags in addition to the git commits.
      #
      # @return [Repository]
      #   The newly cloned repository.
      #
      # @raise [CommandFailed]
      #
      def self.install(uri,path, branch: nil, tag: nil, **kwargs)
        repo = clone(uri,path, **kwargs)

        if branch || tag
          repo.checkout(branch || tag)
        end

        return repo
      end

      #
      # Pulls down new git commits.
      #
      # @param [String] remote
      #   The git remote to pull from.
      #
      # @param [String, nil] branch
      #   The git branch to pull.
      #
      # @param [Boolean] tags
      #   Controls whether to pull git tags in addition to the git commits.
      #
      # @return [true]
      #   Indicates that the `git` command executed successfully.
      #
      # @raise [CommandFailed]
      #
      def pull(remote: 'origin', branch: nil, tags: nil)
        args = []
        args << '--tags' if tags

        args << remote.to_s
        args << branch.to_s if branch

        Dir.chdir(@path) do
          case system('git','pull',*args)
          when nil
            raise(CommandNotInstalled,"git is not installed")
          when false
            raise(CommandFailed,"command failed: git pull #{args.join(' ')}")
          end
        end
      end

      #
      # Checks out the  git branch or tag.
      #
      # @param [String] branch_or_tag
      #   The branch or tag name to checkout.
      #
      # @return [true]
      #   Indicates that the `git` command executed successfully.
      #
      # @raise [CommandFailed]
      #
      def checkout(branch_or_tag)
        Dir.chdir(@path) do
          case system('git','checkout',branch_or_tag)
          when nil
            raise(CommandNotInstalled,"git is not installed")
          when false
            raise(CommandFailed,"command failed: git checkout #{branch_or_tag}")
          end
        end
      end

      #
      # Updates the repository.
      #
      # @return [true]
      #   Indicates that the `git` commands executed successfully.
      #
      # @raise [CommandFailed]
      #   One of the `git` commands failed.
      #
      def update(branch: nil, tag: nil, **kwargs)
        pull(branch: branch, tags: branch.nil?, **kwargs)

        if branch || tag
          checkout(branch || tag)
        end
      end

      #
      # Deletes the repository directory.
      #
      def delete
        FileUtils.rm_rf(@path)
      end

      #
      # Finds a file within the repository.
      #
      # @param [String] path
      #   The relative path of the file.
      #
      # @return [String, nil]
      #   The absolute path of the matching file or `nil` if no matching file
      #   could be found.
      #
      # @example
      #   repo.find_file("wordlists/wordlist.txt")
      #   # => "/home/user/.cache/ronin-repos/foo-repo/wordlists/wordlist.txt"
      #
      def find_file(relative_path)
        path = File.join(@path,relative_path)

        if File.file?(path)
          return path
        end
      end

      #
      # Finds all files in the repository that matches the glob pattern.
      #
      # @param [String] pattern
      #   The file glob pattern to search for.
      #
      # @return [Array<String>]
      #   The absolute paths to the files that match the glob pattern.
      #
      # @example
      #   repo.glob("wordlists/*.txt")
      #   # => ["/home/user/.cache/ronin-repos/foo-repo/wordlists/cities.txt",
      #   #     "/home/user/.cache/ronin-repos/foo-repo/wordlists/states.txt"]
      #
      def glob(pattern,&block)
        path = File.join(@path,pattern)

        return Dir.glob(path,&block)
      end

      #
      # Converts the repository to a String.
      #
      # @return [String]
      #   The name of the repository.
      #
      def to_s
        @name
      end

    end
  end
end
