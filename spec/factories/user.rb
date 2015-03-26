FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    email_verified_at { Time.now.utc }

    factory :admin do
      super_admin true
    end
  end
end

