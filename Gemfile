source "https://rubygems.org"

ruby "2.2.2"

gem "dotenv-rails", "~> 2.0.0", require: "dotenv/rails-now"

gem "coffee-rails", "~> 4.1.0"
gem "jbuilder", "~> 2.0"
gem "jquery-rails"
gem "lograge"
gem "logstash-event"
gem "multi_json"
gem "oj"
gem "pg"
gem "rails", "4.2.2"
gem "rails_config", "~> 0.4.2"
gem "sass-rails", "~> 5.0.2"
gem "sdoc", "~> 0.4.0", group: :doc
gem "uglifier", ">= 1.3.0"
gem "unicorn", "~> 4.8.3"

# MOJ styles
gem "moj_template", "~> 0.23.0"
gem "govuk_frontend_toolkit", "~> 2.0.1"
gem "govuk_elements_rails", "~> 0.1.1"

gem "omniauth-oauth2"
gem "omniauth-dsds", github: "ministryofjustice/defence-request-service-omniauth-dsds", tag: "v0.9.0"
gem "drs-auth_client", github: "ministryofjustice/defence-request-service-auth", tag: "v0.2.2"

# Asset sync - for uploading assets to S3
gem "asset_sync"

group :development do
  gem "web-console", "~> 2.0"
end

group :development, :test do
  gem "awesome_print"
  gem "byebug"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "quiet_assets", "~> 1.1"
  gem "rspec-rails", "~> 3.2.0"
  gem "rubocop", "~> 0.30"
end

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "poltergeist"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop", require: false
  gem "webmock", require: false
end

group :production do
  gem "rack-timeout"
end
