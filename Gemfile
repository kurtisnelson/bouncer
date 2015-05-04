source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails-api'

gem 'analytics-ruby', :require => 'segment/analytics'
gem 'active_model_serializers', '~> 0.9'
gem 'concise_logging'
gem 'devise', '>= 3.4.1'
gem 'doorkeeper', '>= 2.1.3'
gem 'doorkeeper-grants_assertion', github: "uniiverse/doorkeeper-grants_assertion"
gem 'kaminari'
gem 'pg'
gem 'rack-cors', require: "rack/cors"
gem 'sinatra', require: nil
gem 'mandrill-api'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'railsworks'
gem 'rollbar'
gem 'sidekiq'
gem 'skylight'
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
  gem 'rspec-rails', '~> 3.2'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
  gem "codeclimate-test-reporter", require: nil
end

