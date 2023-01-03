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

require 'ronin/repos/version'

require 'command_kit/commands'
require 'command_kit/commands/auto_load'
require 'command_kit/options/version'

module Ronin
  module Repos
    #
    # The `ronin-repos` command-line interface (CLI).
    #
    # @api private
    #
    class CLI

      include CommandKit::Commands
      include CommandKit::Commands::AutoLoad.new(
        dir:       "#{__dir__}/cli/commands",
        namespace: "#{self}::Commands"
      )
      include CommandKit::Options::Version

      command_name 'ronin-repos'
      version Ronin::Repos::VERSION

      command_aliases['ls'] = 'list'
      command_aliases['up'] = 'update'
      command_aliases['rm'] = 'remove'

    end
  end
end
