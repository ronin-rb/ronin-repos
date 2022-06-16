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

require 'ronin/repos'
require 'ronin/core/module_registry'

require 'set'

module Ronin
  module Repos
    #
    # Adds the ability to load modules from directories within installed
    # repositories.
    #
    # ## Example
    #
    # `lib/ronin/exploits.rb`:
    #
    #     require 'ronin/core/module_registry'
    #     require 'ronin/repos/modules_dir'
    #     
    #     module Ronin
    #       module Exploits
    #         include Ronin::Core::ModuleRegistry
    #         include Ronin::Repos::ModulesDir
    #     
    #         modules_dir "#{__dir__}/modules"
    #         repo_modules_dir "exploits"
    #       end
    #     end
    #
    # `lib/ronin/exploits/exploit.rb`:
    #
    #     module Ronin
    #       module Exploits
    #         class Exploit
    #     
    #           def self.register(name)
    #             Exploits.register_module(name,self)
    #           end
    #     
    #         end
    #       end
    #     end
    #
    # `~/.cache/ronin-repos/repo1/exploits/my_exploit.rb`:
    #
    #     require 'ronin/exploits/exploit'
    #     
    #     module Ronin
    #       module Exploits
    #         class MyExploit < Exploit
    #     
    #           register 'my_exploit'
    #     
    #         end
    #       end
    #     end
    #
    # @api semipublic
    #
    module ModulesDir
      def self.included(namespace)
        namespace.send :include, Core::ModuleRegistry
        namespace.extend ClassMethods
      end

      module ClassMethods
        #
        # Gets or sets the repository module directory name.
        #
        # @param [String, nil] new_dir
        #   The new module directory path.
        #
        # @return [String]
        #   The repository module directory name.
        # 
        # @raise [NotImplementedError]
        #   The `repo_modules_dir` method was not defined in the module.
        #
        # @example
        #   repo_modules_dir "exploits"
        #
        def repo_modules_dir(new_dir=nil)
          if new_dir
            @repo_modules_dir = new_dir
          else
            @repo_modules_dir || raise(NotImplementedError,"#{self} did not define a repo_modules_dir")
          end
        end

        #
        # List the module names within the `module_dir` and within
        # {#repo_modules_dir} across all installed repositories.
        #
        # @return [Array<String>]
        # 
        def list_modules
          modules = Set.new(super)
          pattern = File.join(repo_modules_dir,"{**/}*.rb") 

          Repos.list_files(pattern).each do |path|
            modules << path.chomp('.rb')
          end

          return modules.to_a
        end

        #
        # Finds a module within `modules_dir` or within `repo_modules_dir`
        # in one of the installed repositories.
        #
        # @return [String, nil]
        #   The path to the module or `nil` if the module could not be found
        #   in `modules_dir` or any of the installed repositories.
        #
        def find_module(name)
          super(name) ||
            Repos.find_file(File.join(repo_modules_dir,"#{name}.rb"))
        end
      end
    end
  end
end
