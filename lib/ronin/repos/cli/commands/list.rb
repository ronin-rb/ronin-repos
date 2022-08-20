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

require 'ronin/repos/cli/command'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Lists all repositories in the cache directory.
        #
        # ## Usage
        #
        #     ronin-repos list [options] [REPO]
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [REPO]                           Optional repository name to list
        #
        class List < Command

          usage '[options] [REPO]'

          argument :name, required: false,
                          usage:    'REPO',
                          desc:     'Optional repository name to list'

          description 'Lists all repositories in the cache directory'

          man_page 'ronin-repos-list.1'

          #
          # Runs the `ronin-repos list` command.
          #
          # @param [String, nil] name
          #   The optional repo name to list.
          #
          def run(name=nil)
            if name
              begin
                repo = cache_dir[name]

                puts "  #{repo}"
              rescue RepositoryNotFound => error
                print_error(error.message)
                exit(-1)
              end
            else
              cache_dir.each do |repo|
                puts "  #{repo}"
              end
            end
          end

        end
      end
    end
  end
end
