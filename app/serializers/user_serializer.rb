class UserSerializer < JsonApiSerializer
  attributes :id, :image, :phone, :email, :name
  attributes :super_admin, :confirmed_at, :email
end
