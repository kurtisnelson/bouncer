class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter do
    Honeybadger.context({
      user_id: current_user.id,
      user_email: current_user.email
    }) if current_user
  end

  def authenticate_admin!
    return false unless authenticate_user!
    current_user.super_admin?
  end
end
