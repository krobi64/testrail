require 'active_model'
require 'active_support/core_ext'
require 'json'

module Testrail
  class BaseModel
    include ActiveModel::Validations
    extend ActiveModel::Naming
    include Testrail::ClassHelper

    attr_accessor :attributes

    def initialize(attrs)
      attrs = attrs.instance_of?(Hash) ? attrs : {}
      @attributes = attrs.symbolize_keys
      attrs.each do |k, v|
        self.class.build_methods(k)
        set_attr(k,v)
      end
    end

    def to_h
      h = {}.tap do |hash|
        @attributes.each do |k,v|
          hash[k] = v
        end
      end
    end

    def to_json
      json = {}
      json[klass_name] = self.to_h
      JSON.generate(json)
    end

    private

    def client
      @@_client ||= Testrail::Client.new
    end

    def self.client
      @@_client ||= Testrail::Client.new
    end

    def self.build_methods(attribute)
      define_method attribute do
        instance_variable_defined?(:"@#{attribute}") ? instance_variable_get(:"@#{attribute}") : nil
      end

      define_method "#{attribute.to_s}=".to_sym do |*args|
        instance_variable_set(:"@#{attribute}", *args)
      end
    end

    def set_attribute(attr_name, value)
      attributes[attr_name.to_sym] = value
    end

    def get_attribute(attr_name)
      attributes[attr_name.to_sym]
    end

    def set_attr(k, v)
      command = "#{k}=".to_sym
      self.send(command, v)
    end
  end
end
