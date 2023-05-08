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

require 'ronin/repos/cli/command'

require 'command_kit/printing/fields'
require 'command_kit/printing/lists'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Prints information about a specific repository in the cache directory.
        #
        # ## Usage
        #
        #     ronin-repos show [options] REPO
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     REPO                             The repository to display
        #
        # @since 0.2.0
        #
        class Show < Command

          include CommandKit::Printing::Fields
          include CommandKit::Printing::Lists

          usage '[options] [REPO]'

          argument :name, required: true,
                          usage:    'REPO',
                          desc:     'The repository to display'

          description 'Prints information about a repository in the cache directory'

          man_page 'ronin-repos-show.1'

          #
          # Runs the `ronin-repos show` command.
          #
          # @param [String] name
          #   The repo name to display.
          #
          def run(name=nil)
            repo = cache_dir[name]

            puts "[ #{repo} ]"
            puts

            indent do
              print_fields(
                'Name'  => repo.name,
                'URI'   => repo.url,
                'Files' => nil
              )

              indent do
                print_list(repo.list_files)
              end
            end
          rescue RepositoryNotFound => error
            print_error(error.message)
            exit(-1)
          end

        end
      end
    end
  end
end
