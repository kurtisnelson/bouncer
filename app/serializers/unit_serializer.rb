class UnitSerializer < JsonApiSerializer
  attributes :id, :updated_at, :created_at
  attributes :serial
end
