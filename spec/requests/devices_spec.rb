require 'request_helper'

describe 'Device requests' do
  context 'scoped user token' do
    let(:access_token) { FactoryGirl.create(:device_access_token) }
    serial = "1234567890"

    it 'allows a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response).to be_success
      expect(json['devices'][0]['serial']).to eq serial
      expect(json['devices'][0]['links']['user']).to eq access_token.resource_owner_id
    end

    it 'does not allow a duplicate device to be created' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response).to be_success
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response.status).to eq 422
    end

    it 'allows a user to claim a device' do
      device = FactoryGirl.create(:device)
      put device_claim_path(device, format: :json), access_token: access_token.token
      expect(response).to be_success
      expect(json['devices'][0]['links']['user']).to eq access_token.resource_owner_id
    end

    it 'creates token when a device is claimed' do
      device = FactoryGirl.create(:device)
      put device_claim_path(device, format: :json), access_token: access_token.token
      expect(response).to be_success
      token_id = json['devices'][0]['links']['device_token'].to_i
      expect(token_id).to_not be nil
      expect(json['linked']['device_tokens'][0]['id']).to eq token_id
    end
  end

  context 'unscoped user token' do
    let(:access_token) { FactoryGirl.create(:access_token) }
    serial = "1234567890"

    it 'does not allow a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, devices: {serial: serial}
      expect(response.status).to eq 403
    end

    it 'does not allow a user to claim a device' do
      device = FactoryGirl.create(:device)
      put device_claim_path(device, format: :json), access_token: access_token.token
      expect(response.status).to eq 403
    end
  end

  context 'device token' do
    let(:access_token) { FactoryGirl.create(:device_token) }

    it 'allows the device to be unclaimed' do
      put device_unclaim_path(access_token.resource_owner_id, format: :json), access_token: access_token.token
      expect(response).to be_success
    end
  end

  context 'admin token' do
    let(:access_token) { FactoryGirl.create(:admin_access_token) }

    it 'shows all devices' do
      FactoryGirl.create_list(:device, 5)
      get devices_path(format: :json), access_token: access_token.token
      expect(json['devices'].count).to eq 5
    end

    it 'allows removing the device user' do
      device = FactoryGirl.create(:device, user: FactoryGirl.create(:user))
      put device_unclaim_path(device.id, format: :json), access_token: access_token.token
      expect(response.status).to eq 204
    end

    it 'creates token when a device is claimed' do
      device = FactoryGirl.create(:device)
      put device_claim_path(device, format: :json), access_token: access_token.token
      expect(response).to be_success
      token_id = json['devices'][0]['links']['device_token'].to_i
      expect(token_id).to_not be nil
      expect(json['linked']['device_tokens'][0]['id']).to eq token_id
    end
  end

  context 'no auth' do
    it 'is unauthorized' do
      post devices_path(format: :json), devices: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
