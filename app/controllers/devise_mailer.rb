require 'mandrill'
class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts={})
    m = Mandrill::API.new ENV['MANDRILL_KEY']
    template_content = [{"name"=>"example name", "content"=>"example content"}]
    message = {
      to:
        [{email: record.email,
          type: "to"}],
      merge: true,
      merge_vars: [
        {
          rcpt: record.email,
          vars: [
            {name: "CONFIRM_LINK", content: confirmation_url(record, confirmation_token: token)}
          ]
        }
      ]
    }
    m.messages.send_template "confirmation", template_content, message
  end

  def reset_password_instructions(record, token, opts={})
    m = Mandrill::API.new ENV['MANDRILL_KEY']
    template_content = [{"name"=>"example name", "content"=>"example content"}]
    message = {
      to:
        [{email: record.email,
          type: "to"}],
      merge: true,
      merge_vars: [
        {
          rcpt: record.email,
          vars: [
            {name: "PASSWORD_RESET_LINK", content: edit_password_url(record, reset_password_token: token)}
          ]
        }
      ]
    }
    m.messages.send_template "reset-password", template_content, message
  end

  def unlock_instructions(record, token, opts={})
    m = Mandrill::API.new ENV['MANDRILL_KEY']
    template_content = [{"name"=>"example name", "content"=>"example content"}]
    message = {
      to:
        [{email: record.email,
          type: "to"}],
      merge: true,
      merge_vars: [
        {
          rcpt: record.email,
          vars: [
            {name: "UNLOCK_LINK", content: unlock_url(record, unlock_token: token)}
          ]
        }
      ]
    }
    m.messages.send_template "unlock", template_content, message
  end
end
