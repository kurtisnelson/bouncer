FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    confirmed_at { Time.now }

    factory :admin do
      super_admin true
    end
  end
end

