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

require 'ronin/repos/root'
require 'ronin/repos/cache_dir'

require 'ronin/core/cli/command'

module Ronin
  module Repos
    class CLI
      class Command < Core::CLI::Command

        man_dir File.join(ROOT,'man')

        option :cache_dir, short: '-C',
                           value: {
                             type:  String,
                             usage: 'DIR'
                           },
                           desc: 'Overrides the default cache directory' do |dir|
                             @cache_dir = CacheDir.new(dir)
                           end


        # The ronin-repos cache directory.
        #
        # @return [CacheDir]
        attr_reader :cache_dir

        #
        # Initializes the command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for `initialize`.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @cache_dir = CacheDir.new
        end

      end
    end
  end
end
