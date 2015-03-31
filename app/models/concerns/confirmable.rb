module Confirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_email_confirmation_token
    before_create :generate_phone_confirmation_code
    after_create  :send_confirmation_instructions, if: :send_confirmation_email?
    after_create  :send_verification_text, if: :send_verification_text?
  end

  def confirm_email!
    self.email_verified_at = Time.now.utc
    self.save!
  end

  def confirm_phone!
    self.phone_verified_at = Time.now.utc
    self.save!
  end

  def confirmed?
    !!email_verified_at || !!phone_verified_at
  end

  def send_confirmation_instructions
    Mailer.delay.confirmation self.id
  end

  def send_verification_text
    Texter.delay.confirmation self.id
  end

  def reset_confirmation
    generate_email_confirmation_token unless email_confirmed?
    generate_phone_confirmation_code unless phone_confirmed?
    self.save
    #send_confirmation_instructions if send_confirmation_email?
    #send_verification_text if send_verification_text?
  end

  def resend_confirmation_instructions
    pending_any_confirmation do
      send_confirmation_instructions
    end
  end

  def email_confirmed?
    email_verified_at != nil
  end

  def phone_confirmed?
    phone_verified_at != nil
  end

  def active_for_authentication?
    super && confirmed?
  end

  def inactive_message
    !confirmed? ? :unconfirmed : super
  end

  protected

  def pending_any_confirmation
    if !email_confirmed? || !phone_confirmed?
      yield
    else
      self.errors.add(:email, :already_confirmed)
      false
    end
  end

  def generate_email_confirmation_token
    self.email_confirmation_token   = SecureRandom.hex 16
    self.email_confirmation_sent_at = Time.now.utc
  end

  def generate_phone_confirmation_code
    self.phone_verification_code = SecureRandom.hex 2
    self.phone_confirmation_sent_at = Time.now.utc
  end

  def send_confirmation_email?
    !email_confirmed? && self.email.present?
  end

  def send_verification_text?
    !phone_confirmed? && self.phone.present?
  end
end
