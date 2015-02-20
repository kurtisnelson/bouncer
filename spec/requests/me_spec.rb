require 'request_helper'
describe MeController do
  describe 'GET /me' do
    it "fails without a token" do
      get me_path(format: :json)
      expect(response.status).to eq 401
    end

    context "user token" do
      let!(:access_token) { FactoryGirl.create(:access_token) }

      it "succeeeds with a valid token" do
        get me_path(format: :json), access_token: access_token.token
        expect(response).to be_success
        expect(json["users"]).to_not be nil
      end
    end

    context "device token" do
      let!(:access_token) { FactoryGirl.create(:device_token) }

      it "succeeds with a valid token" do
        get me_path(format: :json), access_token: access_token.token
        expect(response).to be_success
        expect(json['devices']).to_not be nil
      end
    end
  end
end
