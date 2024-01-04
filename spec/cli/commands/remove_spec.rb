require 'spec_helper'
require 'ronin/repos/cli/commands/remove'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::Remove do
  include_examples "man_page"
end
