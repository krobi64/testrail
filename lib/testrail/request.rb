require 'httparty'

module Testrail
  class Request
    include HTTParty
    extend Testrail::CommandHelper
    
    base_uri Testrail.config.server
    format :json

    def self.get(command, ids = nil, opts = {})
      opts[:headers] = opts[:headers] ? Testrail.config.headers.merge(opts[:headers]) : Testrail.config.headers
      url = build_command(command, ids)
      res = super(url, opts)
      Testrail::Response.new(res)
    end

    def self.post(command, ids = nil, opts = {})
      opts[:headers] = opts[:headers] ? Testrail.config.headers.merge(opts[:headers]) : Testrail.config.headers
      url = build_command(command, ids)
      res = super(url, opts)
      Testrail::Response.new(res)
    end
  end
end