FactoryGirl.define do
  factory :unit do
    serial { SecureRandom.hex }
  end
end
