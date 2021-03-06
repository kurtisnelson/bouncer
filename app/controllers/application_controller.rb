class ApplicationController < ActionController::API
  include ActionController::Serialization

  UnauthenticatedError     = Class.new(ActionController::ActionControllerError)
  BadRequestError          = Class.new(ActionController::ActionControllerError)
  UnauthorizedError        = Class.new(ActionController::ActionControllerError)

  rescue_from UnauthenticatedError, with: :unauthenticated
  rescue_from BadRequestError, with: :bad_request
  rescue_from UnauthorizedError, with: :unauthorized


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
    unless current_user && current_user.super_admin?
      raise UnauthorizedError
    end
  end

  def page
    (params[:page] || 1).to_i
  end

  def render_json_api obj
    if obj.respond_to? :total_pages
      render json: obj, content_type: "application/vnd.api+json", meta: {total_pages: obj.total_pages}
    else
      render json: obj, content_type: "application/vnd.api+json"
    end
  end

  def authenticate_device_scope_or_admin!
    return if current_user && current_user.super_admin?
    raise UnauthorizedError unless doorkeeper_token.scopes.exists? :device
    raise UnauthorizedError unless current_user
  end

  def authenticate_admin_or_owner! activation
    return if current_user && current_user.super_admin?
    return if current_user && current_user.id = activation.user_id
    return if current_activation && current_activation.id == activation.id
    raise UnauthorizedError
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

  def current_activation
    if doorkeeper_token && doorkeeper_token.accessible?
      Activation.find_by(id: doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end

  private

  def unauthenticated(error)
    head :unauthorized
  end

  def unauthorized(error)
    head :forbidden
  end

  def bad_request(error)
    head :bad_request
  end
end
