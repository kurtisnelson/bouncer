require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'bouncer', :url => ENV['REDIS_URL'] }
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'bouncer', :url => ENV['REDIS_URL'] }
end
