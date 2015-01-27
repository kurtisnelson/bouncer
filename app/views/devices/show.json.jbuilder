json.device do
  json.name @device.name
  json.serial @device.serial
  json.user_id @device.user_id
  json.token @device.token
end
