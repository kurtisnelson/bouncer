class DeviceTokenRepresenter < Roar::Decorator
  include Roar::JSON
  property :resource_owner_id
  property :refresh_token
  property :expires_in_seconds
  property :token, as: :access_token
end
