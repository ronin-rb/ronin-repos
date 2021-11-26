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
        class Install < Command

          argument :uri, required: true,
                         usage:    'URI',
                         desc:     'URI of the git repository'

          description 'Installs a git repository into the cache directory'

          man_page 'ronin-repos-install.1'

          def run(uri)
            log_info "Installing repository from #{uri} ..."
            cache_dir.download(uri)
          rescue CommandFailed => error
            print_error(error.message)
            exit(-1)
          end

        end
      end
    end
  end
end
