ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include SessionHelpers
  include FakeDataApis
  include DateSelectHelpers
end

module Requests
  include ResponseJson
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Features, type: :feature
  config.include Requests, type: :request
  config.include BankHolidayHelpers, type: :bank_holidays
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

ActiveRecord::Migration.maintain_test_schema!
