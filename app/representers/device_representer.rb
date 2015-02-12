class DeviceRepresenter < DevicesRepresenter
  has_one :user
  has_one :device_token

  compound do
    property :device_token, extend: DeviceTokenRepresenter
  end
end
