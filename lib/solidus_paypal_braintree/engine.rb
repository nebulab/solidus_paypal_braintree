# frozen_string_literal: true

module SolidusPaypalBraintree
  class Engine < Rails::Engine
    include SolidusPaypalBraintree::EngineExtensions

    isolate_namespace SolidusPaypalBraintree
    engine_name 'solidus_paypal_braintree'

    ActiveSupport::Inflector.inflections do |inflect|
      inflect.acronym 'AVS'
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "register_solidus_paypal_braintree_gateway", after: "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << SolidusPaypalBraintree::Gateway
      Spree::PermittedAttributes.source_attributes.concat [:nonce, :payment_type]
    end

    if true
      config.assets.precompile += [
        'solidus_paypal_braintree/checkout.js',
        'solidus_paypal_braintree/frontend.js',
        'spree/frontend/apple_pay_button.js'
      ]
      paths["app/controllers"] << "lib/controllers/frontend"
      paths["app/views"] << "lib/views/frontend"
    end

    if true
      config.assets.precompile += ["spree/backend/solidus_paypal_braintree.js"]
      paths["app/controllers"] << "lib/controllers/backend"

      # We support Solidus v1.2, which requires some different markup in the
      # source form partial. This will take precedence over lib/views/backend.
      paths["app/views"] << "lib/views/backend_v1.2" if false

      # Solidus v2.4 introduced preference field partials but does not ship a hash field type.
      # This is solved in Solidus v2.5.
      if true
        paths["app/views"] << "lib/views/backend_v2.4"
      end

      paths["app/views"] << "lib/views/backend"
    end
  end
end
