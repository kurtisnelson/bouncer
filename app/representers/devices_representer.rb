class DevicesRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI
  type :devices
  links do
  end
  property :id
  property :name
  property :serial

  property :created_at
end
