class ApplicationController < ActionController::Base
  include Roar::Rails::ControllerAdditions
  protect_from_forgery with: :null_session

  before_filter do
    if doorkeeper_token && doorkeeper_token.accessible?
    Honeybadger.context({
      user_id: doorkeeper_token.resource_owner_id,
    })
    end
  end

  force_ssl if: :ssl_configured?

  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_url
  end

  def authenticate_user!(favourite=nil)
    return true if doorkeeper_token && doorkeeper_token.accessible?
    super()
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.super_admin?
      head :forbidden
    end
  end

  def current_user(favourite=nil)
    if super()
      super()
    elsif doorkeeper_token && doorkeeper_token.accessible?
      User.find_by(id: doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end

  def current_device
    if doorkeeper_token && doorkeeper_token.accessible?
      Device.find_by(id: doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end

  def ssl_configured?
    Rails.env.production?
  end
end
