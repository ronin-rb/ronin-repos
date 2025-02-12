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

require 'ronin/core/cli/logging'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Updates all or one repository from the cache directory.
        #
        # ## Usage
        #
        #    ronin-repos update [options] [REPO]
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [REPO]                           The repository to update
        #
        class Update < Command

          include Core::CLI::Logging

          usage '[options] [REPO]'

          argument :name, required: false,
                          usage:    'REPO',
                          desc:     'The repository to update'

          description 'Updates all or one repository from the cache directory'

          man_page 'ronin-repos-update.1'

          #
          # Runs the `ronin-repos update` command.
          #
          # @param [String, nil] name
          #   The optional repository name to update.
          #
          def run(name=nil)
            if name
              begin
                repo = cache_dir[name]

                log_info "Updating repository #{repo} ..."
                repo.update
              rescue RepositoryNotFound, CommandFailed => error
                log_error(error.message)
                exit(-1)
              end
            else
              cache_dir.each do |repo|
                log_info "Updating repository #{repo} ..."

                begin
                  repo.update
                rescue CommandNotInstalled, CommandFailed => error
                  log_error("failed to update repository #{repo}: #{error.message}")
                end
              end
            end
          end

        end
      end
    end
  end
end
