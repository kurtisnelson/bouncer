require 'rollbar/rails'
Rollbar.configure do |config|
  if Rails.env.test?
    config.enabled = false
  end

  # config.person_method = "my_current_user"
  # config.person_id_method = "my_id"
  # config.person_username_method = "my_username"
  # config.person_email_method = "my_email"

  config.use_sidekiq
end
