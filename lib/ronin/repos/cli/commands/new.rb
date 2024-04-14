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

require 'ronin/repos/cli/command'
require 'ronin/repos/root'

require 'ronin/core/cli/generator'
require 'ronin/core/git'

module Ronin
  module Repos
    class CLI
      module Commands
        #
        # Creates a new git repository.
        #
        # ## Usage
        #
        #     ronin-repos new [options] PATH
        #
        # ## Options
        #
        #     -C, --cache-dir DIR              Overrides the default cache directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     PATH                             The path to the new repository
        #
        class New < Command

          include Core::CLI::Generator

          template_dir File.join(ROOT,'data','templates','repo')

          usage '[options] PATH'

          argument :path, desc: 'The path to the new repository'

          description 'Creates a new git repository'

          man_page 'ronin-repos-new.1'

          #
          # Runs the `ronin-repos new` command.
          #
          # @param [String] path
          #   The path to the new repo directory to create.
          #
          def run(path)
            @name        = File.basename(path)
            @github_user = Core::Git.github_user || ENV['USER']

            mkdir path
            mkdir File.join(path,'exploits')
            mkdir File.join(path,'payloads')
            mkdir File.join(path,'recon')
            mkdir File.join(path,'brute')
            erb 'README.md.erb', File.join(path,'README.md')

            Dir.chdir(path) do
              sh 'git', 'init', '-q', '-b', 'main'
              sh 'git', 'add', 'README.md'
              sh 'git', 'commit', '-q', '-m', 'Initial commit.'
            end
          end

        end
      end
    end
  end
end
