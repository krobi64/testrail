module Testrail
  class BaseModel
    attr_accessor :attributes

    def initialize(attrs)
      attrs = attrs.instance_of?(Hash) ? attrs : {}
      @attributes = attrs.symbolize_keys
      attrs.each do |k, v|
        self.class.build_methods(k)
        set_attr(k,v)
      end
    end

    private

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

    def get_last_char(symbol)
      text = symbol.to_s
      text[text.length - 1]
    end

    def strip_last_char(symbol)
      text = symbol.to_s
      text.slice(0, text.length - 1)
    end

    def set_attr(k, v)
      command = "#{k}=".to_sym
      self.send(command, v)
    end
  end
end