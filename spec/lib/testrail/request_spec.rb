require 'spec_helper'

describe Testrail::Request do
  subject { Testrail::Request }

  shared_examples_for "a valid HTTPclient request" do
    describe "interface" do
      context "with successful transactions" do
        before do
          stub_request(:any, url_prefix + key).
            with(action_options).
            to_return(body: JSON.generate({result: true, an_object: 'abc'}))
          stub_request(:any, url_prefix + '/789' + key).
            with(action_options).
            to_return(body: JSON.generate({result: true, an_object: 'abc'}))
          stub_request(:any, url_prefix + '/789/a4g8' + key).
            with(action_options).
            to_return(body: JSON.generate({result: true, an_object: 'abc'}))
        end

        it "returns a Testrail::Response object" do
          result = subject.send(method, command, action_options)
          result.should be_instance_of Testrail::Response
        end

        context "with no ids" do
          it "should call the HTTPclient with the correct parameters" do
            subject.send(method, command, action_options)
            WebMock.should have_requested(method, url_prefix + key)
          end
        end

        context "with a single id" do
          it "should call the HTTPclient with the correct parameters" do
            subject.send(method, command, 789, action_options)
            WebMock.should have_requested(method, url_prefix + '/789' + key)
          end
        end

        context "with multiple ids" do
          it "should call the HTTPclient with the correct parameters" do
            subject.send(method, command, [789, 'a4g8'], action_options)
            WebMock.should have_requested(method, url_prefix + '/789/a4g8' + key)
          end
        end
      end
    end

    describe 'error handling' do
      context "with http_error response" do
        before do
          stub_request(:any, server + 'return_http_response_error' + key).
            with(action_options).
            to_return(status: 500)
          @result = subject.send(method, 'return_http_response_error', action_options)
        end

        it "returns a Testrail::Response object" do
          @result.should be_instance_of Testrail::Response
        end

        it "returns a resulting object with @success set to false" do
          @result.success.should be_false
        end

        it "puts the HTTP error type in @error" do
          @result.error.should eq("InternalServerError")
        end
      end

      context "with a timeout" do
        before do
          @timeout_command = 'http_timeout'
          @expected_url = server + @timeout_command + key
          @logger = mock('Logger', error: 'an error')
          Testrail.stub!(:logger).and_return(@logger)
          stub_request(:any, @expected_url).
            with(action_options).
            to_timeout
        end

        it "raises a Timeout::Error" do
          lambda {
            @result = subject.send(method, @timeout_command, action_options)
          }.should raise_error(Timeout::Error)
        end

        context "with a configured logger" do
          it "logs the error" do
            @logger.should_receive(:error).with("Timeout connecting to #{method.to_s.upcase} #{@expected_url}")
            @error = subject.send(method, @timeout_command, action_options) rescue $!
          end
        end

        context "with a nil logger" do
          before do
            Testrail.configure do |config|
              config.logger = nil
            end
          end

          it "does not log the error" do
            Testrail.logger.should_not_receive(:error)
          end

          after do
            Testrail.configure
          end
        end
      end

      context "with any other exception" do
        before do
          @exception_command = 'throw_exception'
          @expected_url = server + @exception_command + key
          @logger = mock('Logger', error: 'an error')
          Testrail.stub!(:logger).and_return(@logger)
          stub_request(:any, @expected_url).
            with(action_options).
            to_raise(StandardError.new('unexpected exception'))
        end

        it "raises the exception" do
          lambda {
            @result = subject.send(method, @exception_command, action_options)
          }.should raise_error(StandardError, 'unexpected exception')
        end

        context "with a configured logger" do
          it "logs the exception" do
            @logger.should_receive(:error).with(/Unexpected exception/)
            @error = subject.send(method, @exception_command, action_options) rescue $!
          end
        end

        context "with a nil logger" do
          before do
            Testrail.configure do |config|
              config.logger = nil
            end
          end

          it "does not log the error" do
            Testrail.logger.should_not_receive(:error)
          end

          after do
            Testrail.configure
          end
        end
      end
    end
  end

  describe ".get" do
    describe "shared behaviors" do
      it_should_behave_like "a valid HTTPclient request" do
        let(:method) { :get }
        let(:action_options) { get_options }
      end
    end
  end

  describe ".post" do
    describe "shared behaviors" do
      it_should_behave_like "a valid HTTPclient request" do
        let(:method) { :post }
        let(:action_options) { post_options }
      end
    end
  end
end
