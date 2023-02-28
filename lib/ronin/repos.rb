# frozen_string_literal: true
#
# Copyright (c) 2021-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/repos/cache_dir'

module Ronin
  #
  # Top-level methods for accessing repositories.
  #
  # @api public
  #
  module Repos
    @cache_dir = CacheDir.new

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
    def self.find_file(path)
      @cache_dir.find_file(path)
    end

    #
    # Finds all files in all repos that matches the glob pattern
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
    def self.glob(pattern,&block)
      @cache_dir.glob(pattern,&block)
    end

    #
    # Lists all files across all installed repos.
    #
    # @param [String] pattern
    #   The glob pattern to use to list specific files.
    #
    # @return [Set<String>]
    #   The matching files within all repositories.
    #
    def self.list_files(pattern='{**/}*.*')
      @cache_dir.list_files(pattern)
    end
  end
end
