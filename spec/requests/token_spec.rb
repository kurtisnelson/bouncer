require 'request_helper'
describe CustomTokenInfoController do
  describe 'GET /oauth/token/info' do
    context "user token" do
      let!(:access_token) { FactoryGirl.create(:access_token) }

      it 'returns token info' do
        get oauth_token_info_path(format: :json), access_token: access_token.token
        expect(response).to be_success
        expect(User.find(json['resource_owner_id'])).to_not be nil
      end
    end

    context 'activation token' do
      let!(:access_token) { FactoryGirl.create(:activation_token) }

      it 'returns token info' do
        get oauth_token_info_path(format: :json), access_token: access_token.token
        expect(response).to be_success
        expect(Activation.find(json['resource_owner_id'])).to_not be nil
      end
    end
  end
end
