class Device
  include MongoMapper::Document
  belongs_to :user
  key :name, String
  key :serial, String, unique: true
  key :code, String
  timestamps!
end
