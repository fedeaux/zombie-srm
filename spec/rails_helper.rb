# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'chromedriver-helper'
require 'database_cleaner'

# require 'devise'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  config.include Rails.application.routes.url_helpers
  # config.include ActiveJob::TestHelper

  # ActiveJob::Base.queue_adapter = :test
  Capybara.default_max_wait_time = 1000
  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
