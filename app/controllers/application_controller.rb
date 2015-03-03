class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  UnauthorizedError        = Class.new(ActionController::ActionControllerError)
  UnauthenticatedError     = Class.new(ActionController::ActionControllerError)
  BadRequestError          = Class.new(ActionController::ActionControllerError)

  rescue_from UnauthorizedError, with: :unauthorized
  rescue_from UnauthenticatedError, with: :unauthenticated
  rescue_from BadRequestError, with: :bad_request

  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_url
  end

  def current_service
    return false unless request.headers['authorization']
    auth = request.headers['authorization'].split(' ')
    return false unless auth[0] == 'JWT'
    begin
      token = JWT.decode(auth[1], ENV['JWT_SECRET'])
      token[0]['service']
    rescue JWT::DecodeError
      nil
    end
  end

  def authenticate!
    authenticate_user!
  end

  def authenticate_user!(favourite=nil)
    return true if doorkeeper_token && doorkeeper_token.accessible?
    return true if current_service
    super()
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.super_admin?
      raise UnauthorizedError
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

  private
  def unauthorized(error)
    head :forbidden
  end

  def unauthenticated(error)
    head :unauthorized
  end

  def bad_request(error)
    head :bad_request
  end
end
