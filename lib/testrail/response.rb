require 'forwardable'

module Testrail
  class Response
    attr_reader :http_response
    
    extend Forwardable

    def_delegators :http_response, :request, :response, :code, :body

    def initialize(http_response)
      @http_response = http_response
    end
  end
end