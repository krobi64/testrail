module Testrail
  module CommandHelper
    def build_url(command, ids = nil)
      command = Testrail.config.server + Testrail.config.api_path + command
      unless ids.nil?
        ids = '/' + [ids].flatten.join('/')
        command += ids
      end
      command + key
    end

    private
    def key
      '&key=' + String(Testrail.config.api_key)
    end
  end
end
