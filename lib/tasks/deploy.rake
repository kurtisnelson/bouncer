desc "Deploy master"
task :deploy do
  REV = `git log -n 1 --pretty=format:"%H"`
  USER = `whoami`
  sh "aws --region='us-east-1' opsworks create-deployment --stack-id='84b1f7e9-bf0a-4c22-8bd9-e95b77347017' --app-id='997aaf39-f92e-4f6e-884a-f4a7534e84a3' --command='{\"Name\": \"deploy\"}'"
  sh "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{ENV['ROLLBAR_ACCESS_TOKEN']} -F environment=production -F revision=#{REV} -F local_username=#{USER}"
end
