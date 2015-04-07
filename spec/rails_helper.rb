ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "omniauth-dsds/spec/sign_in_helper"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Omniauth::Dsds::Spec::SignInHelper
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

ActiveRecord::Migration.maintain_test_schema!
