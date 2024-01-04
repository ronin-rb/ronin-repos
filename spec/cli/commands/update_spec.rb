require 'spec_helper'
require 'ronin/repos/cli/commands/update'
require_relative 'man_page_example'

describe Ronin::Repos::CLI::Commands::Update do
  include_examples "man_page"
end
