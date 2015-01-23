require 'request_helper'
describe MeController do
  describe 'GET /me' do
    it "fails without a token" do
      get me_path
      expect(response.status).to eq 401
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

  describe 'POST /me' do
    it "fails without a token" do
      post me_path
      expect(response.status).to eq 401
    end

    context 'valid token' do
      let!(:application) { FactoryGirl.create :application } # OAuth application
      let!(:user)        { FactoryGirl.create :user }
      let!(:access_token)       { FactoryGirl.create(:access_token, :application => application, :resource_owner_id => user.id) }

      it 'allows phone number to be updated' do
        number = "1234567890"
        post me_path, access_token: access_token.token, user: {phone: number}
        user.reload
        expect(user.phone).to eq number
      end
    end
  end
end
