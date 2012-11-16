require 'spec_helper'

describe Testrail do
  subject { Testrail }

  describe ".config" do
    it "returns a Testrail::Config object" do
      subject.config.should be_instance_of(Testrail::Config)
    end
  end

  describe ".configure" do
    context "without a block" do
      before do
        @default_config = subject.config.dup
        @actual_config = subject.configure
      end

      it "returns the default configuration" do
        @actual_config.server.should eq(@default_config.server)
        @actual_config.api_path.should eq(@default_config.api_path)
        @actual_config.api_key.should eq(@default_config.api_key)
        @actual_config.logger.should be_instance_of(Logger)
      end
    end

    context "with a block" do
      before do
        @default_config = subject.config.dup
        @new_config = subject.configure { |config|
          config.server = 'localhost'
        }
      end

      it "overrides specified settings" do
        subject.config.server.should eq(@new_config.server)
      end

      it "retains any default settings not overwritten" do
        subject.config.api_path.should eq(@default_config.api_path)
        subject.config.api_key.should eq(@default_config.api_key)
        subject.config.logger.should be_instance_of(Logger)
      end
    end

    describe "@server & @api_path" do
      context "with default settings" do
        it "points to the Cloud Server" do
          subject.config.server.should eq('https://example.testrail.com')
          subject.config.api_path.should eq('/index.php?/miniapi/')
        end
      end

      context "with custom settings" do
        before do
          @new_server = new_server = 'http://localhost'
          @new_api_path = new_api_path = '/some_path/'
          debugger
          subject.configure do |config|
            config.server = new_server
            config.api_path = new_api_path
          end
        end

        it "points to the new server" do
          subject.config.server.should eq(@new_server)
        end

        it "sets the new api_path" do
          subject.config.api_path.should eq(@new_api_path)
        end
      end
    end

    describe "@api_key" do
      context "with default settings" do
        it "is nil" do
          subject.config.api_key.should be_nil
        end
      end

      context "with custom settings" do
        before do
          @new_api_key = new_api_key = 'my_new_api_key'
          subject.configure do |config|
            config.api_key = new_api_key
          end
        end

        it "sets the new api_key" do
          subject.config.api_key.should eq(@new_api_key)
        end
      end
    end

    describe "@logger" do
      context "with default settings" do
        it "sets the logger to a Logger instance" do
          subject.config.logger.should be_instance_of Logger
        end

        it "sets the output to STDOUT" do
          Logger.stub!(:new)
          Logger.should_receive(:new).with(STDOUT)
          subject.configure
        end
      end
      
      context "with custom settings" do
        before do
          @mock_logger = mock_logger = mock('A Different Logger')
          subject.configure do |config|
            config.logger = mock_logger
          end
        end

        it "returns the custom log object" do
          subject.config.logger.should eq(@mock_logger)
        end
      end
    end
  end

  after do
    Testrail.configure
  end
end