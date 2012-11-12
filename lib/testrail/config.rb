require 'yaml'

module Testrail

  def self.configure(&block)
    @config = Config.new(&block).config
  end

  def self.config
    @config ||= Config.new.config
  end

  class Config
    attr_accessor :headers, :server, :api_path, :api_key

    def initialize(&block)
      default_config
      instance_eval(&block) if block_given?
    end

    def default_config
      @headers = { accept: "application/json" }
      @server = "https://example.testrail.com"
      @api_path = "/index.php?/miniapi/"
      @api_key = nil
    end

    def config
      self
    end
  end
end