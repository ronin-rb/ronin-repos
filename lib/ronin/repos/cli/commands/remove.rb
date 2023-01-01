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

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Deletes a repository from the cache directory.
        #
        # ## Usage
        #
        #     ronin-repos remove [options] NAME
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     REPO                             URI of the git repository
        #
        class Remove < Command

          usage '[options] NAME'

          argument :name, required: true,
                          usage:    'REPO',
                          desc:     'URI of the git repository'

          description 'Deletes a repository from the cache directory'

          man_page 'ronin-repos-remove.1'

          #
          # Runs the `ronin-repos remove` command.
          #
          # @param [String] name
          #   The repository name to remove.
          #
          def run(name)
            repo = cache_dir[name]
            repo.delete
          rescue RepositoryNotFound => error
            print_error(error.message)
            exit(-1)
          end

        end
      end
    end
  end
end
