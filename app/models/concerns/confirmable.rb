module Confirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_confirmation_token, if: :confirmation_required?
    after_create  :send_on_create_confirmation_instructions, if: :send_confirmation_notification?
  end

  def confirm!(args={})
    pending_any_confirmation do
      if confirmation_period_expired?
        self.errors.add(:email, :confirmation_period_expired,
                        period: Devise::TimeInflector.time_ago_in_words(self.class.confirm_within.ago))
        return false
      end

      self.email_verified_at = Time.now.utc

      saved = save(validate: args[:ensure_valid] == true)
      after_confirmation if saved
      saved
    end
  end

  def confirmed?
    !!email_verified_at || !!phone_verified_at
  end

  def send_confirmation_instructions
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    send_devise_notification(:confirmation_instructions, @raw_confirmation_token)
  end

  def resend_confirmation_instructions
    pending_any_confirmation do
      send_confirmation_instructions
    end
  end

  def confirmation_required?
    !!email_verified_at && !!phone_verified_at
  end

  def active_for_authentication?
    super && confirmed?
  end

  def inactive_message
    !confirmed? ? :unconfirmed : super
  end

  protected

  # A callback method used to deliver confirmation
  # instructions on creation. This can be overridden
  # in models to map to a nice sign up e-mail.
  def send_on_create_confirmation_instructions
    send_confirmation_instructions
  end

  def pending_any_confirmation
    if confirmation_required?
      yield
    else
      self.errors.add(:email, :already_confirmed)
      false
    end
  end

  def generate_confirmation_token
    raw, enc = Devise.token_generator.generate(self.class, :confirmation_token)
    @raw_confirmation_token   = raw
    self.confirmation_token   = enc
    self.confirmation_sent_at = Time.now.utc
  end

  def generate_confirmation_token!
    generate_confirmation_token && save(validate: false)
  end

  def send_confirmation_notification?
    confirmation_required? && !@skip_confirmation_notification && self.email.present?
  end

  module ClassMethods
    # Attempt to find a user by its email. If a record is found, send new
    # confirmation instructions to it. If not, try searching for a user by unconfirmed_email
    # field. If no user is found, returns a new user with an email not found error.
    # Options must contain the user email
    def send_confirmation_instructions(attributes={})
      confirmable = find_by_unconfirmed_email_with_errors(attributes) if reconfirmable
      unless confirmable.try(:persisted?)
        confirmable = find_or_initialize_with_errors(confirmation_keys, attributes, :not_found)
      end
      confirmable.resend_confirmation_instructions if confirmable.persisted?
      confirmable
    end

    # Find a user by its confirmation token and try to confirm it.
    # If no user is found, returns a new user with an error.
    # If the user is already confirmed, create an error for the user
    # Options must have the confirmation_token
    def confirm_by_token(confirmation_token)
      original_token     = confirmation_token
      confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)

      confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
      confirmable.confirm! if confirmable.persisted?
      confirmable.confirmation_token = original_token
      confirmable
    end

    # Find a record for confirmation by unconfirmed email field
    def find_by_unconfirmed_email_with_errors(attributes = {})
      unconfirmed_required_attributes = confirmation_keys.map { |k| k == :email ? :unconfirmed_email : k }
      unconfirmed_attributes = attributes.symbolize_keys
      unconfirmed_attributes[:unconfirmed_email] = unconfirmed_attributes.delete(:email)
      find_or_initialize_with_errors(unconfirmed_required_attributes, unconfirmed_attributes, :not_found)
    end

    Devise::Models.config(self, :allow_unconfirmed_access_for, :confirmation_keys, :reconfirmable, :confirm_within)
  end

end
