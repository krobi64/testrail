require 'httparty'

module Testrail
  class Request
    include HTTParty
    extend Testrail::CommandHelper
    
    base_uri Testrail.config.server
    format :json

    def self.get(*args)
      command, ids, opts = parse_args(*args)
      url = build_command(command, ids)
      Testrail::Response.new(super(url, opts))
    end

    def self.post(*args)
      command, ids, opts = parse_args(*args)
      url = build_command(command, ids)
      Testrail::Response.new(super(url, opts))
    end

    private
    def self.parse_args(*args)
      opts = args.last.instance_of?(Hash) ? args.pop : {}
      opts[:headers] = opts[:headers] ? Testrail.config.headers.merge(opts[:headers]) : Testrail.config.headers
      command = args.shift
      ids = args.empty? ? nil : args
      [command, ids, opts]
    end
  end
end