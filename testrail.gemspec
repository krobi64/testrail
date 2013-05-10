$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'testrail/version'


Gem::Specification.new do |s|
  s.name             = "testrail"
  s.version          = Testrail::VERSION
  s.authors          = ["Kristine Robison"]
  s.summary          = "A Ruby client library for TestRail"
  s.description      = """
    A Ruby client that tries to match TestRail's API one-to-one, while still
    providing an idiomatic interface.
  """
  s.email            = "krobison@gmail.com"
  s.homepage         = "http://github.com/kris-at-tout/testrail"
  s.licenses         = ["MIT"]
  s.require_paths    = ["lib"]

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files            = Dir['lib/**/*'] + ['Gemfile', 'Rakefile', 'README.md', 'LICENSE.txt']
  s.test_files       = Dir['spec/**/*']
  
  s.add_dependency 'httparty',     '~> 0.11.0'

  s.add_development_dependency 'rake',         '~> 10.0.3'
  s.add_development_dependency 'rspec',        '~> 2.8.0'
  s.add_development_dependency 'debugger',     '~> 1.5.0'
  s.add_development_dependency 'rdoc',         '~> 3.12.2'
  s.add_development_dependency 'webmock',      '~> 1.9.3'
  s.add_development_dependency 'simplecov',    '~> 0.7.1'
end

