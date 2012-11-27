Dir[File.join(File.dirname(__FILE__), 'models', '**', '*.rb')].each do |f|
  require f
end
