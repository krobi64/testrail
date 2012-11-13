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
      parse_error if Integer(http_response.code) >= 400
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

    def parse_error
      @success = false
      @error = ::Net::HTTPResponse::CODE_TO_OBJ[http_response.code.to_s].name.gsub!(/Net::HTTP/, '')
    end
  end
end