require 'rollbar/rails'
Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.exception_level_filters.merge!('ActiveRecord::RecordNotFound' => 'ignore')
  config.exception_level_filters.merge!('ActionController::RoutingError' => 'ignore')
  # Here we'll disable in 'test':
  if Rails.env.test?
    config.enabled = false
  end

  config.use_sidekiq 'queue' => 'rollbar'
end
