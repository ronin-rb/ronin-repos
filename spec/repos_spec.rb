require 'spec_helper'
require 'ronin/repos'

describe Ronin::Repos do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end

  let(:cache_dir) { described_class.instance_variable_get('@cache_dir') }

  describe "@cache_dir" do
    subject { cache_dir }

    it "must be a CacheDir pointing to ~/.cache/ronin-repos" do
      expect(subject).to be_kind_of(Ronin::Repos::CacheDir)
      expect(subject.path).to eq(File.expand_path("~/.cache/ronin-repos"))
    end
  end

  describe ".find_file" do
    let(:relative_path) { 'file.txt' }
    let(:matches) do
      [
        "/path/to/repo1/file.txt",
        "/path/to/repo2/file.txt"
      ]
    end

    it "must call @cache_dir.find_file" do
      expect(cache_dir).to receive(:find_file).with(relative_path).and_return(matches)

      expect(subject.find_file(relative_path)).to be(matches)
    end
  end

  describe ".glob" do
    let(:pattern) { 'dir/*.txt' }
    let(:matches) do
      [
        "/path/to/repo1/dir/file.txt",
        "/path/to/repo2/dir/file.txt"
      ]
    end

    it "must call @cache_dir.glob" do
      expect(cache_dir).to receive(:glob).with(pattern).and_return(matches)

      expect(subject.glob(pattern)).to be(matches)
    end
  end

  describe ".list_files" do
    let(:pattern) { 'dir/*.txt' }
    let(:files) do
      Set[
        "dir/file.txt",
        "dir/file.txt"
      ]
    end

    it "must call @cache_dir.list_files" do
      expect(cache_dir).to receive(:list_files).with(pattern).and_return(files)

      expect(subject.list_files(pattern)).to be(files)
    end
  end
end
