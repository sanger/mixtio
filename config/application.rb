require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mixtio
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.load_defaults 5.1

    config.eager_load_paths += %W(#{config.root}/lib/validators #{config.root}/app/forms #{config.root}/lib)

    config.filter_parameters += [:password]

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_specs: false,
            helper_specs: false,
            routing_specs: false,
            controller_specs: false,
            request_specs: true
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.stub_ldap = false

    config.ldap = OpenStruct.new(Rails.application.config_for(:ldap))

    config.print_service = config_for(:print_service)
    config.mailer = config_for(:mailer)

    config.barcode_prefix = 'RGNT_'

    config.active_record.sqlite3.represent_boolean_as_integer = true

    config.support_email = 'mixtio-help@sanger.ac.uk'

    config.snow_start = 'Dec 11'
    config.snow_end = 'Dec 30'
  end
end

