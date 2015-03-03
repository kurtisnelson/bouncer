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
