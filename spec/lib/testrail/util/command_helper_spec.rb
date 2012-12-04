require 'spec_helper'

class TestClass
  extend Testrail::CommandHelper
end

describe Testrail::CommandHelper do
  subject { TestClass }
  let(:key) { '&key=' + String(Testrail.config.api_key) }
  let(:url_prefix) { Testrail.config.server + Testrail.config.api_path}

  describe ".build_url" do
    context "with nil id" do
      before do
        @command = subject.build_url('a_command')
      end

      it "creates a valid URL" do
        @command.should eq( url_prefix + 'a_command' + key )
      end
    end

    context "with a single id" do
      before do
        @command = subject.build_url('a_command', 235)
      end

      it "creates a valid URL" do
        @command.should eq( url_prefix + 'a_command/235' + key )
      end
    end

    context "with an array of ids" do
      before do
        @command = subject.build_url('a_command', [235, 'ax45'])
      end

      it "creates a valid URL" do
        @command.should eq( url_prefix + 'a_command/235/ax45' + key)
      end
    end
  end
end
