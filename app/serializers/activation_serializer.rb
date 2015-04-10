class ActivationSerializer < JsonApiSerializer
  attributes :id, :updated_at, :created_at
  attributes :links

  def links
    {
      unit: object.unit_id && object.unit_id.to_param,
      device: object.device_id && object.device_id.to_param,
      user: object.user_id && object.user_id.to_param,
      activation_token: object.token && object.token.to_param
    }
  end

  def as_json(*args)
    hash = super(*args)

    hash[:linked] =
      ActivationTokenSerializer.new(
        object.token,
      ).as_json

    hash
  end
end
