require 'spec_helper'

describe Testrail do
  subject { Testrail.logger }

  describe ".logger" do
    it "memoizes the logger instance" do
      @logger2 = Testrail.logger
      subject.should equal(@logger2)
    end
  end
end