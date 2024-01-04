require 'spec_helper'
require 'ronin/repos/cli/commands/new'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::New do
  include_examples "man_page"
end
