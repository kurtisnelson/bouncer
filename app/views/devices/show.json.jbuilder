json.device @device

json.token do |t|
  json.access_token @device.device_token.token
  json.refresh_token @device.device_token.refresh_token
  json.expires_in @device.device_token.expires_in
end
