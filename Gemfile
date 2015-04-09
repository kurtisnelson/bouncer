source 'https://rubygems.org'

ruby '2.2.0'
gem 'rails', '4.2.1'

gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
gem 'active_model_serializers', '~> 0.9'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'coffee-rails'
gem 'devise', '>= 3.4.1'
gem 'doorkeeper', '>= 2.1.3'
gem 'doorkeeper-grants_assertion', github: "uniiverse/doorkeeper-grants_assertion"
gem 'jquery-rails'
gem 'lograge'
gem 'pg'
gem 'rack-cors', require: "rack/cors"
gem 'sinatra', require: nil
gem 'mandrill-api'
gem 'newrelic_rpm'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'parse-ruby-client'
gem 'railsworks'
gem 'rollbar'
gem 'sass-rails', '>= 3.2'
gem 'sidekiq'
gem 'simple_form'
gem 'slim-rails'
gem 'therubyracer'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

group :production, :staging do
  gem 'remote_syslog'
end

group :development, :test do
  gem 'aws-sdk'
  gem 'pry'
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'yard', '~>0.8.1'
  gem 'yard-rest'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 3.2.1'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'web-console', '~> 2.0'
  gem 'webmock'
  gem "codeclimate-test-reporter", require: nil
end

