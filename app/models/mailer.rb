require 'mandrill'
class Mailer
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.confirmation user_id
    user = User.find(user_id)
    Mailer.new.confirmation user
  end

  def confirmation user
    url = url_helpers.user_confirm_url(user, confirmation_token: user.email_confirmation_token)
    message = build_message(user.email, "CONFIRM_LINK", url)
    send_mandrill_template "confirmation", message
  end

  def password_reset user, token
    message = build_message(record.email, "PASSWORD_RESET_LINK", edit_password_url(record, reset_password_token: token))
    send_mandrill_template "reset-password", message
  end

  def unlock user, token
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