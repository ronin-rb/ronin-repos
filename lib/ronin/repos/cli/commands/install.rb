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

require 'ronin/core/cli/logging'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Installs a git repository into the cache directory.
        #
        # ## Usage
        #
        #    ronin-repos install [options] [REPO]
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     URI                              URI of the git repository
        #
        class Install < Command

          include Core::CLI::Logging

          usage '[options] URI'

          argument :uri, required: true,
                         usage:    'URI',
                         desc:     'URI of the git repository'

          description 'Installs a git repository into the cache directory'

          man_page 'ronin-repos-install.1'

          #
          # Runs the `ronin-repos install` command.
          #
          # @param [String] uri
          #   The repository's git URI to install from.
          #
          def run(uri)
            log_info "Installing repository from #{uri} ..."
            cache_dir.install(uri)
          rescue CommandFailed => error
            print_error(error.message)
            exit(-1)
          end

        end
      end
    end
  end
end
