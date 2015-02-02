require 'mandrill'
class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts={})
    message = build_message(record.email, "CONFIRM_LINK", confirmation_url(record, confirmation_token: token))
    send_mandrill_template "confirmation", message
  end

  def reset_password_instructions(record, token, opts={})
    message = build_message(record.email, "PASSWORD_RESET_LINK", edit_password_url(record, reset_password_token: token))
    send_mandrill_template "reset-password", message
  end

  def unlock_instructions(record, token, opts={})
    message = build_message(record.email, "UNLOCK_LINK", unlock_url(record, unlock_token: token))
    send_mandrill_template "unlock", message
  end

  private

  def send_mandrill_template name, message
    template_content = [{"name"=>"example name", "content"=>"example content"}]
    mandrill.messages.send_template name, template_content, message
  end
  def mandrill
    Mandrill::API.new ENV['MANDRILL_KEY']
  end

  def build_message recipient, name, url
    {
      to:
        [{email: recipient,
          type: "to"}],
      merge: true,
      merge_vars: [
        {
          rcpt: recipient,
          vars: [
            {name: name, content: url}
          ]
        }
      ]
    }
  end
end
