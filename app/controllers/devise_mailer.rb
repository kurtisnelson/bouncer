class DeviseMailer < Devise::Mailer

  def reset_password_instructions(record, token, opts={})
    Mailer.delay.password_reset record.id
  end

  def unlock_instructions(record, token, opts={})
    Mailer.delay.unlock record.id
  end
end
