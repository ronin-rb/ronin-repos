require 'spec_helper'
require 'ronin/repos/cli/commands/install'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::Install do
  include_examples "man_page"
end
