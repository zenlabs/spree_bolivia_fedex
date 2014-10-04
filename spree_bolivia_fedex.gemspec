# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_bolivia_fedex'
  s.version     = '0.0.1'
  s.summary     = 'Spree Bolivia for Fedex service'
  s.description = "This extension will allow you to use Bolivia Fedex, this is VERY poor implementation because fedex not calculate the rates"
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Carlos Ramos'
  s.email     = 'cr@zenlabs.net'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
end
