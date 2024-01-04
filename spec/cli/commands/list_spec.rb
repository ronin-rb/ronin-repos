require 'spec_helper'
require 'ronin/repos/cli/commands/list'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::List do
  include_examples "man_page"
end
