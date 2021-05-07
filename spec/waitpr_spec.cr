require "./spec_helper"

require "yaml"
describe WaitPR do
  it "has matching versions" do
    shard_version = File.open("shard.yml") { |f| YAML.parse f }["version"]
    shard_version.should eq WaitPR::VERSION
  end
end
