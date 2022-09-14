#
# Copyright (c) 2021 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/repos/repository'
require 'ronin/core/home'

require 'set'

module Ronin
  module Repos
    #
    # Manages the `~/.cache/ronin-repos/` directory and the repositories
    # contained within.
    #
    # @api private
    #
    class CacheDir

      include Enumerable

      # The ~/.cache/ronin-repos/ directory where all repos are stored.
      PATH = Core::Home.cache_dir('ronin-repos')

      # The path to the cache directory.
      #
      # @return [String]
      attr_reader :path

      #
      # Initializes the repository cache.
      #
      # @param [String] path
      #   The path to the repository cache directory.
      #
      def initialize(path=PATH)
        @path = path
      end

      # 
      # Accesses a repository from the cache directory.
      #
      # @param [String] name
      #   The name of the repository.
      #
      # @return [Repository]
      #   The repository from the cache.
      #
      # @raise [RepositoryNotFound]
      #   No repository exists with the given name in the cache directory.
      #
      def [](name)
        path = File.join(@path,name.to_s)

        unless File.directory?(path)
          raise(RepositoryNotFound,"repository not found: #{name.inspect}")
        end

        return Repository.new(path)
      end

      #
      # Enumerates through every repository in the cache directory.
      #
      # @yield [repo]
      #   The given block will be passed each repository.
      #
      # @yieldparam [Repository] repo
      #   A repository from the cache directory.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each
        return enum_for unless block_given?

        each_child_directory do |path|
          yield Repository.new(path)
        end
      end

      #
      # Clones and installs a repository into the cache directory.
      #
      # @param [String, URI::HTTPS] uri
      #   The URI to clone the repository from.
      #
      # @param [String, nil] name
      #   The explicit name of the repository to use. Defaults to the base-name
      #   of the URI's path, sans any `.git` extension.
      #
      # @return [Repository]
      #   The newly installed repository.
      #
      # @raise [CommandFailed]
      #   One of the `git` commands failed.
      #
      # @raise [CommandNotInstalled]
      #   The `git` command is not installed.
      #
      def install(uri,name=nil)
        uri    = uri.to_s
        name ||= File.basename(uri,File.extname(uri))
        path   = File.join(@path,name)

        return Repository.install(uri,path)
      end

      #
      # Updates all repositories in the cache directory.
      #
      # @raise [CommandNotInstalled]
      #   The `git` command is not installed.
      #
      def update
        each do |repo|
          begin
            repo.update
          rescue CommandFailed
          end
        end
      end

      #
      # Removes a repository from the cache directory.
      #
      # @param [String] name
      #   The repository name to find and delete.
      #
      # @raise [RepositoryNotFound]
      #   The repository with the given name does not exist in the cache
      #   directory.
      #
      def remove(name)
        self[name].delete
      end

      #
      # Deletes all repositories in the cache directory.
      #
      def purge
        each(&:delete)
      end

      #
      # Finds the first matching file.
      #
      # @param [String] path
      #   The relative path of the file.
      #
      # @return [String, nil]
      #   The absolute path of the matching file or `nil` if no matching file
      #   could be found.
      #
      # @example
      #   repos.find_file("wordlists/wordlist.txt")
      #   # => "/home/user/.cache/ronin-repos/foo-repo/wordlists/wordlist.txt"
      #
      def find_file(path)
        each do |repo|
          if (file = repo.find_file(path))
            return file
          end
        end
      end

      #
      # Finds all files in all repos that matches the glob pattern.
      #
      # @param [String] pattern
      #   The file glob pattern to search for.
      #
      # @return [Array<String>]
      #   The absolute paths to the files that match the glob pattern.
      #
      # @example
      #   repos.glob("wordlists/*.txt")
      #   # => ["/home/user/.cache/ronin-repos/foo-repo/wordlists/cities.txt",
      #   #     "/home/user/.cache/ronin-repos/foo-repo/wordlists/states.txt",
      #   #     "/home/user/.cache/ronin-repos/bar-repo/wordlists/bands.txt",
      #   #     "/home/user/.cache/ronin-repos/bar-repo/wordlists/beers.txt"]
      #
      def glob(pattern,&block)
        return enum_for(__method__,pattern).to_a unless block_given?

        each do |repo|
          repo.glob(pattern,&block)
        end
      end

      #
      # Lists all files across all repos installed in the cache directory.
      #
      # @param [String] pattern
      #   The optional glob pattern to use to list specific files.
      #
      # @return [Set<String>]
      #   The matching paths within the repository.
      #
      # @example
      #   repos.list_files('exploits/{**/}*.rb')
      #   # => #<Set: {"exploits/exploit1.rb", "exploits/exploit2.rb"}>
      #
      def list_files(pattern='{**/}*.*')
        each_with_object(Set.new) do |repo,files|
          files.merge(repo.list_files(pattern))
        end
      end

      #
      # Converts the cache directory to a String.
      #
      # @return [String]
      #   The path to the cache directory.
      #
      def to_s
        @path
      end

      private

      #
      # Enumerates over each directory in the cache directory.
      #
      # @yield [dir]
      #   The given block will be passed each repository's directory path.
      #
      # @yieldparam [String] dir
      #   A path to a repository directory within the cache directory.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each_child_directory
        return enum_for(__method__) unless block_given?

        if File.directory?(@path)
          Dir.children(@path).sort.each do |name|
            path = File.join(@path,name)

            if File.directory?(path)
              yield path
            end
          end
        end

        return nil
      end

    end
  end
end
