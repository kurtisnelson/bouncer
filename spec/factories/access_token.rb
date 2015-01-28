FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id { create(:user).id }
    application
    expires_in 2.hours

    factory :device_access_token do
      scopes "device"
    end
    factory :clientless_access_token do
      application nil
    end
  end

  factory :device_token, class: Doorkeeper::DeviceToken do
    resource_owner_id { create(:device).id }
    application
    expires_in 2.hours
    scopes "device"
  end
end
