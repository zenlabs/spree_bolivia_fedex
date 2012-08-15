module SpreeCanadaPost
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_canada_post'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.register.calculators" do |app|
      require 'spree/calculator/canada_post_regular'
      require 'spree/calculator/canada_post_expedited'
      require 'spree/calculator/canada_post_usa_small_surface'
      app.config.spree.calculators.shipping_methods << Spree::Calculator::CanadaPostRegular
      app.config.spree.calculators.shipping_methods << Spree::Calculator::CanadaPostExpedited
      app.config.spree.calculators.shipping_methods << Spree::Calculator::CanadaPostUsaSmallSurface
    end

    config.to_prepare &method(:activate).to_proc
  end
end

    