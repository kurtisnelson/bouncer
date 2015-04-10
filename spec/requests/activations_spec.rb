require 'request_helper'

describe 'Activation requests' do
  let(:unit) { FactoryGirl.create(:unit) }
  context 'scoped user token' do
    let(:access_token) { FactoryGirl.create(:device_access_token) }
    let(:device_id) { SecureRandom.uuid }

    it 'allows a user to activate a unit' do
      post activations_path(format: :json), activations: {serial: unit.serial, device: device_id }, access_token: access_token.token
      expect(response).to be_success
      expect(json['activations'][0]['links']['user']).to eq access_token.resource_owner_id
      expect(json['activations'][0]['links']['unit']).to eq unit.id
      expect(json['activations'][0]['links']['device']).to eq device_id
    end

    it 'allows a user to deactivate a unit' do
      activation = FactoryGirl.create(:activation, user_id: access_token.resource_owner_id)
      delete activation_path(activation.id, format: :json), access_token: access_token.token
      expect(response).to be_success
    end

    it 'has a token after activation' do
      post activations_path(format: :json), activations: {serial: unit.serial, device: device_id }, access_token: access_token.token
      expect(response).to be_success
      token_id = json['activations'][0]['links']['activation_token'].to_i
      expect(token_id).to_not be nil
      expect(json['linked']['activation_tokens'][0]['id']).to eq token_id
    end

    it 'has a token after activate -> deactivate -> activate' do
      post activations_path(format: :json), activations: {serial: unit.serial, device: device_id}, access_token: access_token.token
      id = json['activations'][0]['id']
      delete activation_path(id, format: :json), access_token: access_token.token
      post activations_path(format: :json), activations: {serial: unit.serial, device: SecureRandom.uuid}, access_token: access_token.token
      expect(response).to be_success
      token_id = json['activations'][0]['links']['activation_token'].to_i
      expect(token_id).to_not be nil
      expect(json['linked']['activation_tokens'][0]['id']).to eq token_id
    end
  end
end
