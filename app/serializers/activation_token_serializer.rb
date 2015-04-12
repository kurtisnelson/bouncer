class ActivationTokenSerializer < JsonApiSerializer
  attributes :id, :token, :expires_in_seconds, :refresh_token

  def activation
    object.resource_owner_id
  end
end
