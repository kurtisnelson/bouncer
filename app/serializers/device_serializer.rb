class DeviceSerializer < JsonApiSerializer
  attributes :id, :name, :serial, :created_at
  attributes :links

  def links
    {
      user: object.user && object.user.to_param,
      device_token: object.device_token && object.device_token.to_param
    }
  end

  def as_json(*args)
    hash = super(*args)

    hash[:linked] =
      DeviceTokenSerializer.new(
        object.device_token,
      ).as_json

    hash
  end
end
