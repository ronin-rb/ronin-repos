require 'rspec'
require 'ronin/repos/cache_dir'

shared_examples_for "global CacheDir" do
  attr_reader :cache_dir_path
  attr_reader :cache_dir

  before(:all) do
    @original_cache_dir = Ronin::Repos.instance_variable_get(:@cache_dir)

    @cache_dir_path = File.join(__dir__,'fixtures','cache')
    @cache_dir      = Ronin::Repos::CacheDir.new(@cache_dir_path)

    Ronin::Repos.instance_variable_set(:@cache_dir,@cache_dir)
  end

  after(:all) do
    Ronin::Repos.instance_variable_set(:@cache_dir,@original_cache_dir)
  end
end
