# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_canada_post'
  s.version     = '1.1.0'
  s.summary     = 'Spree Canada Post Extension'
  s.description = "This extension will allow you to use Canada Post shipment's methods by using their API.
                   You'll be able to calculate automaticaly and dynamicly the shipment price."
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Olivier Buffon'
  # s.email     = 'you@example.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.1.0'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sqlite3'
end
