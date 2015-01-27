require 'request_helper'

describe DevicesController do
  context 'user token' do
    let!(:access_token) { FactoryGirl.create(:machine_access_token) }

    it 'allows a device to be created' do
      post devices_path(format: :json), access_token: access_token.token, device: {serial: '1234567890'}
      expect(response).to be_success
    end
  end
  context 'no auth' do
    it 'is unauthorized' do
      post devices_path(format: :json), device: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
