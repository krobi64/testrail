require 'testrail/config'
require 'testrail/request'
require 'testrail/response'
require 'testrail/client'

module Testrail
  def self.logger
    Testrail.config.logger
  end
end
