require 'request_helper'

describe 'Device requests' do
  context 'user token' do
    let(:access_token) { FactoryGirl.create(:device_access_token) }
    serial = "1234567890"

    it 'allows a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response).to be_success
      expect(json['devices']['serial']).to eq serial
      expect(json['devices']['links']['user']).to eq access_token.resource_owner_id
    end

    it 'assigns a token to a new device' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(json['linked']['device_token'][0]).to_not be_empty
      expect(json['linked']['device_token'][0]['access_token']).to_not be_empty
      expect(json['linked']['device_token'][0]['refresh_token']).to_not be_empty
    end

    it 'does not allow a duplicate device to be created' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response.status).to eq 400
    end

    it 'does not allow a user to update another device' do
      id = SecureRandom.uuid
      FactoryGirl.create(:device, id: id)
      patch device_path(id, format: :json), access_token: access_token.token
      expect(response.status).to eq 403
    end

    it 'allows the device name to be changed' do
      id = SecureRandom.uuid
      FactoryGirl.create(:device, id: id, user_id: access_token.resource_owner_id)
      name = Faker::Name.name
      patch device_path(id, format: :json), access_token: access_token.token, devices: {name: name }
      expect(json['devices']['name']).to eq name
      expect(json['devices']['links']['user']).to eq access_token.resource_owner_id
    end
  end

  context 'admin token' do
    let(:access_token) { FactoryGirl.create(:admin_access_token) }

    it 'shows all devices' do
      FactoryGirl.create_list(:device, 5)
      get devices_path(format: :json), access_token: access_token.token
      expect(json['devices'].count).to eq 5
    end

    it 'allows updating the device name and user' do
      id = SecureRandom.uuid
      FactoryGirl.create(:device, id: id)
      name = Faker::Name.name
      user = FactoryGirl.create(:user)
      patch device_path(id, format: :json), access_token: access_token.token, devices: {name: name, user: user.id}
      expect(json['devices']['name']).to eq name
      expect(json['devices']['links']['user']).to eq user.id
    end
  end

  context 'no auth' do
    it 'is unauthorized' do
      post devices_path(format: :json), devices: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
