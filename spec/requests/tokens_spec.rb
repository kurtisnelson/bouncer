require 'request_helper'
describe TokensController do
  describe 'GET /me' do
    it "fails without a token" do
      get me_path
      expect(response).to_not be_success
    end

    context "valid token" do
      let!(:application) { FactoryGirl.create :application } # OAuth application
      let!(:user)        { FactoryGirl.create :user }
      let!(:access_token)       { FactoryGirl.create(:access_token, :application => application, :resource_owner_id => user.id) }

      it "succeeeds with a valid token" do
        get me_path, access_token: access_token.token
        expect(response).to be_success
        expect(json["user"]).to_not be nil
      end
    end
  end
end
