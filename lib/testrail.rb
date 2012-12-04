Dir[File.join(File.dirname(__FILE__), 'testrail', 'util', '*.rb')].each do |f|
  require f
end

Dir[File.join(File.dirname(__FILE__), 'testrail', '*.rb')].each do |f|
  require f
end

module Testrail
  def self.logger
    Testrail.config.logger
  end
end
