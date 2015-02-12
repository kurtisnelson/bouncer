require 'request_helper'

describe 'Device requests' do
  context 'user token' do
    let(:access_token) { FactoryGirl.create(:device_access_token) }
    serial = "1234567890"

    it 'allows a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(response).to be_success
      expect(json['devices']['serial']).to eq serial
      expect(json['devices']['links']['user']).to eq access_token.resource_owner_id.to_s
    end

    it 'assigns a token to a new device' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(json['linked']['device_token'][0]).to_not be_empty
      expect(json['linked']['device_token'][0]['access_token']).to_not be_empty
      expect(json['linked']['device_token'][0]['refresh_token']).to_not be_empty
    end

    it 'does not allow a duplicate device to be created' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(response.status).to eq 400
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
      serial = SecureRandom.hex
      patch device_path(id, format: :json), access_token: access_token.token, device: {name: name, serial: serial}
      expect(json['devices']['name']).to eq name
      expect(json['devices']['serial']).to eq serial
    end
  end

  context 'no auth' do
    it 'is unauthorized' do
      post devices_path(format: :json), device: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
