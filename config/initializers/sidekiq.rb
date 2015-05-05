require 'sidekiq'

if ENV['RACK_ENV'] == "docker"
  redis_domain = ENV['REDIS_1_PORT_6379_TCP_ADDR']
  redis_port   = ENV['REDIS_1_PORT_6379_TCP_PORT']
  ENV['REDIS_URL'] ="redis://#{redis_domain}:#{redis_port}"
end
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'bouncer', :url => ENV['REDIS_URL'] }
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'bouncer', :url => ENV['REDIS_URL'] }
end
