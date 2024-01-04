require 'spec_helper'
require 'ronin/repos/cli/commands/purge'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::Purge do
  include_examples "man_page"
end
