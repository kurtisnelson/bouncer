json.devices @devices do |device|
  json.id device.id
  json.serial device.serial
  json.name device.name
end
