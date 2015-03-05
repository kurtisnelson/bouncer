run "bundle exec rake papertrail:start" # Start remote_syslog daemon to push logs to papertrail
node[:deploy].each do |application, deploy|
  run "bundle exec rake sidekiq:stop"
  run "bundle exec rake sidekiq:start"
end
