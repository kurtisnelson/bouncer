FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    email_verified_at { Time.now.utc }
      factory :admin do
        super_admin true
      end
    factory :unconfirmed_user do
      email_verified_at nil
      phone_verified_at nil
    end
  end
end

