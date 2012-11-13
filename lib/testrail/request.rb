require 'httparty'

module Testrail
  class Request
    include HTTParty
    extend Testrail::CommandHelper
    
    base_uri Testrail.config.server
    format :json

    def self.get(*args)
      opts = args.last.instance_of?(Hash) ? args.pop : {}
      opts[:headers] = opts[:headers] ? Testrail.config.headers.merge(opts[:headers]) : Testrail.config.headers
      command = args.shift
      ids = args.empty? ? nil : args
      url = build_command(command, ids)
      res = super(url, opts)
      Testrail::Response.new(res)
    end

    def self.post(*args)
      opts = args.last.instance_of?(Hash) ? args.pop : {}
      opts[:headers] = opts[:headers] ? Testrail.config.headers.merge(opts[:headers]) : Testrail.config.headers
      command = args.shift
      ids = args.empty? ? nil : args
      url = build_command(command, ids)
      res = super(url, opts)
      Testrail::Response.new(res)
    end
  end
end