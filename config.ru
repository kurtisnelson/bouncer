# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'bouncer' && password == ENV['SIDEKIQ_PASSWORD']
  end

  run Sidekiq::Web
end

# Horrendous hack to allow us to run sidekiq jobs within the same free dyno
# as the web process.
if ENV["RAILS_ENV"] == "production" || ENV["RACK_ENV"] == "production"
  fork do
    Process.exec("bundle exec sidekiq")
  end
end
