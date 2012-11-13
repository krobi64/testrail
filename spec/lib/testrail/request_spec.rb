require 'spec_helper'

describe Testrail::Request do
  subject { Testrail::Request }
  let(:command) { 'a_command' }
  let(:url_prefix) { Testrail.config.server + Testrail.config.api_path + command }
  let(:key) { '&key=' + String(Testrail.config.api_key) }
  let(:headers) { Testrail.config.headers }
  let(:body) {
    {
      an_object: {
        param1: 'a value',
        param2: 'another value',
        param3: 42
      }
    }
  }
  let(:post_options) { { headers: headers, body: body} }
  let(:get_options)  { { headers: headers} }

  shared_examples_for "a correct HTTPclient messenger" do
    describe "interface" do
      before do
        stub_request(:any, url_prefix + key).to_return(body: JSON.generate({result: true, an_object: 'abc'}))
        stub_request(:any, url_prefix + '/789' + key).to_return(body: JSON.generate({result: true, an_object: 'abc'}))
        stub_request(:any, url_prefix + '/789/a4g8' + key).to_return(body: JSON.generate({result: true, an_object: 'abc'}))
      end

      it "returns a Testrail::Response object" do
        result = subject.send(method, command, nil, action_options)
        result.should be_instance_of Testrail::Response
      end

      context "with no ids" do
        it "should call the HTTPclient with the correct parameters" do
          subject.send(method, command, nil, action_options)
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

  describe ".get" do
    describe "shared behaviors" do
      it_should_behave_like "a correct HTTPclient messenger" do
        let(:method) { :get }
        let(:action_options) { get_options }
      end
    end
  end

  describe ".post" do
    describe "shared behaviors" do
      it_should_behave_like "a correct HTTPclient messenger" do
        let(:method) { :post }
        let(:action_options) { post_options }
      end
    end
  end
end