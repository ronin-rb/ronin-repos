# frozen_string_literal: true
#
# Copyright (c) 2021-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../command'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Lists all repositories in the cache directory.
        #
        # ## Usage
        #
        #     ronin-repos list [options] [NAME]
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [NAME]                           Optional repository name(s) to list
        #
        class List < Command

          usage '[options] [NAME]'

          argument :name, required: false,
                          usage:    'NAME',
                          desc:     'Optional repository name(s) to list'

          description 'Lists all repositories in the cache directory'

          man_page 'ronin-repos-list.1'

          #
          # Runs the `ronin-repos list` command.
          #
          # @param [String, nil] name
          #   The optional repo name to list.
          #
          def run(name=nil)
            repos = if name
                      cache_dir.select do |repo|
                        repo.name.include?(name)
                      end
                    else
                      cache_dir.each
                    end

            repos.each do |repo|
              puts "  #{repo}"
            end
          end

        end
      end
    end
  end
end
