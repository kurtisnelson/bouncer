json.device do
  json.name @device.name
  json.serial @device.serial
  json.user_id @device.user_id
end

json.token do |t|
  json.access_token @device.device_token.token
  json.refresh_token @device.device_token.refresh_token
  json.expires_in @device.device_token.expires_in
end
