require 'mandrill'
class Mailer
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.confirmation user_id, uri = URI.parse(ENV['CONFIRMATION_URL'])
    user = User.find(user_id)
    Mailer.new.confirmation user, uri
  end

  def self.password_reset user_id, uri = URI.parse(ENV['PASSWORD_RESET_URL'])
    user = User.find(user_id)
    Mailer.new.password_reset user, uri
  end

  def confirmation user, uri
    new_query_ar = URI.decode_www_form(uri.query || '') << ["confirmation_token", user.email_confirmation_token]
    uri.query = URI.encode_www_form(new_query_ar)
    message = build_message(user.email, "CONFIRM_LINK", uri.to_s)
    send_mandrill_template "confirmation", message
  end

  def password_reset user, uri
    new_query_ar = URI.decode_www_form(uri.query || '') << ["reset_password_token", user.reset_password_token]
    uri.query = URI.encode_www_form(new_query_ar)
    message = build_message(user.email, "PASSWORD_RESET_LINK", uri.to_s)
    send_mandrill_template "reset-password", message
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
