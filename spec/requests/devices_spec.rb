require 'request_helper'

describe DevicesController do
  context 'user token' do
    let!(:access_token) { FactoryGirl.create(:machine_access_token) }
    serial = "1234567890"

    it 'allows a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(response).to be_success
      expect(json['device']['serial']).to eq serial
      expect(json['device']['user_id']).to eq access_token.resource_owner_id.to_s
    end

    it 'assigns a token to a new device' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(json['device']['token']).to_not be nil
    end

    it 'does not allow a duplicate device to be created' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      post devices_path(format: :json), access_token: access_token.token, device: {serial: serial}
      expect(response.status).to eq 400
    end
  end

  context 'no auth' do
    it 'is unauthorized' do
      post devices_path(format: :json), device: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
