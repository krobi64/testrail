require 'logger'

module Testrail

  def self.configure(&block)
    @config = Config.new &block
  end

  def self.config
    @config ||= Config.new
  end

  class Config
    attr_accessor :headers, :server, :api_path, :api_key, :logger

    def initialize(&block)
      default_config
      instance_eval(&block) if block_given?
    end

    def default_config
      @headers = {
        "Accept" => "application/json"
      }
      @server = "https://example.testrail.com"
      @api_path = "/index.php?/miniapi/"
      @api_key = nil
      @logger = Logger.new STDOUT
    end
  end
end