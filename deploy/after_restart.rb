token = new_resource.environment['ROLLBAR_ACCESS_TOKEN']
rev = new_resource.revision
user = new_resource.user
run "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{token} -F environment=#{new_resource.environment['RAILS_ENV']} -F revision=#{rev} -F local_username=#{user}"
