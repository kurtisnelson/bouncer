require 'request_helper'

describe 'Unit requests' do
  let(:device_id) { SecureRandom.uuid }
  context 'scoped user token' do
    let(:access_token) { FactoryGirl.create(:device_access_token) }
    serial = "1234567890"

    it 'allows a unit to be created' do
      post units_path(format: :json), access_token: access_token.token, units: {serial: serial}
      expect(response).to be_success
      expect(json['units'][0]['serial']).to eq serial
    end

    it 'does not allow a duplicate unit to be created' do
      post units_path(format: :json), access_token: access_token.token, units: {serial: serial}
      expect(response).to be_success
      post units_path(format: :json), access_token: access_token.token, units: {serial: serial}
      expect(response.status).to eq 422
    end


  end

  context 'unscoped user token' do
    let(:access_token) { FactoryGirl.create(:access_token) }
    serial = "1234567890"

    it 'does not allow a unit to be created' do
      post units_path(format: :json), access_token: access_token.token, units: {serial: serial}
      expect(response.status).to eq 403
    end

    it 'does not allow a user to activate a device' do
      post activations_path(format: :json), activations: {serial: serial, device: device_id }, access_token: access_token.token
      expect(response.status).to eq 403
    end
  end

  context 'admin token' do
    let(:access_token) { FactoryGirl.create(:admin_access_token) }

    it 'shows all units' do
      FactoryGirl.create_list(:unit, 5)
      get units_path(format: :json), access_token: access_token.token
      expect(json['units'].count).to eq 5
    end
  end

  context 'no auth' do
    it 'is unauthorized' do
      post units_path(format: :json), units: {serial: '1234567890'}
      expect(response.status).to eq 401
    end
  end
end
