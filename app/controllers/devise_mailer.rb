class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    Emailer.password_reset(record, token)
  end

  def unlock_instructions(record, token, opts={})
    Emailer.unlock record, token
  end
end
