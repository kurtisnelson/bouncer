class DeviceTokenSerializer < JsonApiSerializer
  attributes :id, :resource_owner_id, :refresh_token, :expires_in_seconds, :access_token

  def access_token
    object.token
  end
end
