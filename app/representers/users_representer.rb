require 'roar/coercion'
module UsersRepresenter
  include Roar::JSON::JSONAPI
  include Roar::Coercion
  type :users
  link(:self) { user_url(represented) }

  property :id
  property :email
  property :image
  property :phone
  property :super_admin

  property :confirmed_at, type: DateTime
end
