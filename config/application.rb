require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DefenceRequestServiceRota
  class Application < Rails::Application

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.action_controller.action_on_unpermitted_parameters = :raise
    config.active_record.raise_in_transactional_callbacks = true

    config.relative_url_root = ENV['RAILS_RELATIVE_URL_ROOT'] || ''
    # Application Title (Populates <title>)
    config.app_title = 'Defence Solicitor Duty Rota'
    # Proposition Title (Populates proposition header)
    config.proposition_title = 'Defence Solicitor Duty Rota'
    # Current Phase (Sets the current phase and the colour of phase tags)
    # Presumed values: alpha, beta, live
    config.phase = 'alpha'
    # Product Type (Adds class to body based on service type)
    # Presumed values: information, service
    config.product_type = 'service'
    # Feedback URL (URL for feedback link in phase banner)
    config.feedback_url = config.relative_url_root + '/feedback/new'
  end
end
