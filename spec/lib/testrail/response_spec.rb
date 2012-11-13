require 'spec_helper'

class TestResponse
  attr_accessor :body
  def initialize(opts = nil)
    unless opts.nil?
      @body = JSON.generate(opts) rescue opts
    end
  end
end

describe Testrail::Response do
  subject { Testrail::Response }

  describe "initialize" do
    before do
      @response1 = subject.new
      @response2 = subject.new(TestResponse.new( result: true, some_obj: {id: 1, msg: 'some_msg'}))
      @response3 = subject.new(TestResponse.new( result: false, error: 'Some error'))
      @response4 = subject.new(TestResponse.new('something_with_malformed_response'))
    end

    context "success" do
      it "assigns nothing to @success if the response.body is nil" do
        @response1.success.should be_nil
      end
    
      it "assigns the result method to @success" do
        @response2.success.should be_true
        @response3.success.should be_false
      end

      it "assigns false to @success if the response body isn't valid JSON" do
        @response4.success.should be_false
      end
    end

    context "error" do
      it "should be nil if the response body is nil" do
        @response1.error.should be_nil
      end

      it "should be nil if the result value in the response body is true" do
        @response2.error.should be_nil
      end

      it "should contain the error message returned in the body if result is false" do
        @response3.error.should eq('Some error')
      end

      it "should assign a Malformed JSON error if the response body isn't valid JSON" do
        @response4.error.should =~ /Malformed JSON response/
      end
    end

    context "body" do
      it "should be nil if the response body is nil" do
        @response1.body.should be_nil
      end

      it "should be nil if the response body result is false" do
        @response3.body.should be_nil
      end

      it "should be set to the response body object if the result is true" do
        @response2.body.should eq({"some_obj" => {"id" => 1, "msg" => 'some_msg'}})
      end

      it "should be nil if the response body isn't valid JSON" do
        @response4.body.should be_nil
      end
    end
  end
end