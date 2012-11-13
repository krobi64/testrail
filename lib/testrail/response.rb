require 'forwardable'
require 'json'

module Testrail
  class Response
    attr_reader :http_response
    attr_accessor :success, :body, :error
    
    extend Forwardable

    def_delegators :http_response, :request, :response, :code

    def initialize(http_response = nil)
      @http_response = http_response
      parse_body if http_response.respond_to?(:body) && !http_response.body.nil?
    end

    private
    def parse_body
      result_body = JSON.parse(http_response.body) rescue nil
      if result_body
        @success = result_body.delete('result') rescue nil
        @body = @success ? result_body : nil
        @error = result_body.delete('error') rescue nil
      else
        @success = false
        @error = "Malformed JSON response.\n Received #{http_response.body}"
      end
    end
  end
end