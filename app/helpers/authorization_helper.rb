module AuthorizationHelper
  UnauthorizedError        = Class.new(ActionController::ActionControllerError)

  def authenticate_device_scope_or_admin!
    return if current_user && current_user.super_admin?
    doorkeeper_authorize!
    raise UnauthorizedError unless doorkeeper_token.scopes.exists? :device
  end

  def authenticate_admin_or_owner! device
    return if current_user && current_user.super_admin?
    return if current_user && current_user.id = device.user_id
    return if current_device && current_device.id = device.id
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

  def current_device
    if doorkeeper_token && doorkeeper_token.accessible?
      Device.find_by(id: doorkeeper_token.resource_owner_id)
    else
      nil
    end
  end
end
