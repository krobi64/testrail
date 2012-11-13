require 'spec_helper'

class TestResponse
  attr_accessor :body, :code
  def initialize(code, opts = nil)
    @code = code
    unless opts.nil?
      @body = JSON.generate(opts) rescue opts
    end
  end
end

describe Testrail::Response do
  subject { Testrail::Response }

  describe "initialize" do
    context "with unsuccessful server response" do
      before do
        @response1 = subject.new(TestResponse.new('500'))
        @response2 = subject.new(TestResponse.new('404'))
        @response3 = subject.new(TestResponse.new('401'))
        @response4 = subject.new(TestResponse.new('403'))
      end

      it "assigns false to @success" do
        @response1.success.should be_false
        @response2.success.should be_false
        @response3.success.should be_false
        @response4.success.should be_false
      end

      it "assigns the code definition to @error" do
        @response1.error.should eq('InternalServerError')
        @response2.error.should eq('NotFound')
        @response3.error.should eq('Unauthorized')
        @response4.error.should eq('Forbidden')
      end

      it "does not assign anything to @payload" do
        @response1.payload.should be_nil
        @response2.payload.should be_nil
        @response3.payload.should be_nil
        @response4.payload.should be_nil
      end
    end

    context "with successful response, but no body" do
      before do
        @response = subject.new(TestResponse.new(200))
      end

      it "does not assign anything to @success" do
        @response.success.should be_nil
      end
    
      it "does not assign anything to @error" do
        @response.error.should be_nil
      end

      it "does not assign anything to @payload" do
        @response.payload.should be_nil
      end
    end

    context "with successful response, including a body" do
      before do
        @response = subject.new(TestResponse.new(200, result: true, some_obj: {id: 1, msg: 'some_msg'}))
      end

      it "assigns true to @success" do
        @response.success.should be_true
      end

      it "does not assign anything to @error" do
        @response.error.should be_nil
      end

      it "assigns the response body object to @payload" do
        @response.payload.should eq({"some_obj" => {"id" => 1, "msg" => 'some_msg'}})
      end
    end

    context "with the server successfully sending back an error" do
      before do
        @response = subject.new(TestResponse.new(200, result: false, error: 'Some error'))
      end

      it "assigns false to @success" do
        @response.success.should be_false
      end

      it "assigns the returned error message to @error" do
        @response.error.should eq('Some error')
      end

      it "does not assign anything to @payload" do
        @response.payload.should be_nil
      end
    end

    context "with the server returning an invalid JSON object" do
      before do
        @response = subject.new(TestResponse.new(200, 'something_with_malformed_response'))
      end

      it "assigns false to @success" do
        @response.success.should be_false
      end

      it "assigns a Malformed JSON error message to @error" do
        @response.error.should =~ /Malformed JSON response/
      end

      it "does not assign anything to @payload" do
        @response.payload.should be_nil
      end
    end
  end
end