require 'simplecov'
SimpleCov.start 'rails'
require 'vcr'
require 'sidekiq/testing'
require 'webmock/rspec'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.ignore_localhost = true
    c.ignore_hosts 'codeclimate.com'
    c.filter_sensitive_data('MANDRILL_KEY') { ENV['MANDRILL_KEY'] }
    c.filter_sensitive_data('FACEBOOK_SECRET') { ENV['FACEBOOK_SECRET'] }
  end
end
