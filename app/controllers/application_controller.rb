class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_filter do
    Honeybadger.context({
      user_id: current_user.id,
      user_email: current_user.email
    }) if current_user
  end

  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_url
  end

  def authenticate_user!
    return true if doorkeeper_token && doorkeeper_token.accessible?
    super
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.super_admin?
      head :forbidden
    end
  end

  def current_user
    if super
      super
    elsif doorkeeper_token && doorkeeper_token.accessible?
      User.find(doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end

  def current_device
    if doorkeeper_token && doorkeeper_token.accessible?
      Device.find(doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end
end
