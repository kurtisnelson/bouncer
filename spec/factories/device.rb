FactoryGirl.define do
  factory :device do
    serial { SecureRandom.hex }
  end
end
