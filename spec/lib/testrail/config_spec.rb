require 'spec_helper'

describe Testrail do
  subject { Testrail }

  describe "default settings" do
    it "points to the Cloud Server" do
      subject.config.server.should eq('https://example.testrail.com')
      subject.config.api_path.should eq('/index.php?/miniapi/')
    end

    it "has a nil apikey" do
      subject.config.api_key.should be_nil
    end
  end

  describe ".configure" do
    before do
      Testrail.configure do |config|
        config.api_key = 'an_api_key'
      end
    end

    it "takes a block as options" do
      subject.config.api_key.should eq('an_api_key')
    end

    it "retains any default settings not overwritten" do
      subject.config.server.should eq('https://example.testrail.com')
      subject.config.api_path.should eq('/index.php?/miniapi/')
    end
  end

  describe ".config" do
    before do
      Testrail.configure do |config|
        config.api_key = 'an_api_key'
        config.server = 'localhost'
      end
    end

    it "returns a Testrail::Config object" do
      Testrail.config.should be_instance_of(Testrail::Config)
    end
  end
end