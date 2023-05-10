require 'spec_helper'
require 'global_cache_dir_examples'

require 'ronin/repos'

describe Ronin::Repos do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end

  describe ".cache_dir" do
    subject { super().cache_dir }

    it "must be a CacheDir pointing to ~/.cache/ronin-repos" do
      expect(subject).to be_kind_of(Ronin::Repos::CacheDir)
      expect(subject.path).to eq(File.expand_path("~/.cache/ronin-repos"))
    end
  end

  describe ".find_file" do
    include_examples 'global CacheDir'

    let(:file) { 'file1.txt' }

    it "must call @cache_dir.find_file" do
      expect(subject.find_file(file)).to eq("#{cache_dir_path}/repo1/#{file}")
    end
  end

  describe ".glob" do
    include_examples 'global CacheDir'

    it "must call @cache_dir.glob" do
      expect(subject.glob("dir/*.txt")).to eq(
        [
          "#{cache_dir_path}/repo1/dir/file3.txt",
          "#{cache_dir_path}/repo2/dir/file3.txt",
          "#{cache_dir_path}/repo2/dir/file4.txt"
        ]
      )
    end
  end

  describe ".list_files" do
    include_examples 'global CacheDir'

    it "must call @cache_dir.list_files" do
      expect(subject.list_files("dir/*.txt")).to eq(
        Set[
          "dir/file3.txt",
          "dir/file3.txt",
          "dir/file4.txt"
        ]
      )
    end
  end
end
