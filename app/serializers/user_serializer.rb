class UserSerializer < JsonApiSerializer
  attributes :id, :image, :phone, :super_admin, :confirmed_at
end
