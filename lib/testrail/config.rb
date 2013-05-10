require 'logger'
require 'active_support/configurable'

module Testrail

  def self.configure(&block)
    @config = Config.new
    yield @config if block_given?
  end

  def self.config
    @config ||= Config.new
  end

  class Config
    include ActiveSupport::Configurable
    config_accessor :headers, :server, :api_path, :api_key, :logger

    def initialize
      default_config
    end

    def default_config
      self.headers = {
        "Accept" => "application/json"
      }
      self.server = "https://example.testrail.com"
      self.api_path = "/index.php?/miniapi/"
      self.api_key = nil
      self.logger = Logger.new STDOUT
    end
  end
end