class ActivationTokenSerializer < JsonApiSerializer
  attributes :id, :token, :expires_in_seconds

  def activation
    object.resource_owner_id
  end
end
