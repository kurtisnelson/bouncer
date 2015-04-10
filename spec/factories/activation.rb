FactoryGirl.define do
  factory :activation do
    unit
    user
    device_id SecureRandom.uuid
  end
end
