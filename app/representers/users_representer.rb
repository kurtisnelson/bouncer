module UsersRepresenter
  include Roar::JSON::JSONAPI
  type :users

  property :id
  property :email
  property :image
  property :phone
  property :super_admin

  property :confirmed_at
end
