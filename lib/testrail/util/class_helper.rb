module Testrail
  module ClassHelper
    def klass_name
      @klass_name ||= base_name.underscore.to_sym
    end

    def base_name
      self.class.name.split('::').last
    end

    def get_last_char(symbol)
      text = symbol.to_s
      text[text.length - 1]
    end

    def strip_last_char(symbol)
      text = symbol.to_s
      text.slice(0, text.length - 1)
    end
  end
end