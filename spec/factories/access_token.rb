FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id { create(:user).id }
    application
    expires_in 2.hours

    factory :device_access_token do
      scopes "device"
    end
    factory :admin_access_token do
      resource_owner_id { create(:admin).id }
    end
    factory :clientless_access_token do
      application nil
    end
  end

  factory :activation_token, class: Doorkeeper::ActivationToken do
    resource_owner_id { create(:activation).id }
    application
    expires_in 2.weeks
  end
end
