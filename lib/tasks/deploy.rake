desc "Deploy master"
task :deploy do
  sh "aws --region='us-east-1' opsworks create-deployment --stack-id='84b1f7e9-bf0a-4c22-8bd9-e95b77347017' --app-id='997aaf39-f92e-4f6e-884a-f4a7534e84a3' --command='{\"Name\": \"deploy\", \"Args\":{\"migrate\":[\"true\"]}}'"
end
