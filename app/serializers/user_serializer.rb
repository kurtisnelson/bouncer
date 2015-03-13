class UserSerializer < JsonApiSerializer
  attributes :id, :image, :name
  attributes :super_admin
  attributes :phone, :phone_verified_at
  attributes :email, :email_verified_at
end
