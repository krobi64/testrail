require 'spec_helper'

describe Testrail do
  it "must be defined" do
    Testrail::VERSION.should_not be_nil
  end
end