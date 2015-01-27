FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    resource_owner_id { create(:user).id }
    application
    expires_in 2.hours

    factory :machine_access_token do
      scopes "machine"
    end
    factory :clientless_access_token do
      application nil
    end
  end
end
