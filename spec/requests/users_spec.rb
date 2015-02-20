require 'request_helper'

describe 'User requests' do
  let(:user_token) { FactoryGirl.create(:access_token) }

  it 'fails for plain users' do
    get users_path(format: :json), access_token: user_token.token
    expect(response.status).to eq 403
  end

  describe 'POST /users/me' do
    it "fails without a token" do
      post '/users/me.json'
      expect(response.status).to eq 401
    end

    context 'valid token' do
      let!(:application) { FactoryGirl.create :application } # OAuth application
      let!(:user)        { FactoryGirl.create :user }
      let!(:access_token)       { FactoryGirl.create(:access_token, :application => application, :resource_owner_id => user.id) }

      it 'allows phone number to be updated' do
        number = "1234567890"
        post '/users/me.json', access_token: access_token.token, user: {phone: number}
        expect(response).to be_success
        user.reload
        expect(user.phone).to eq number
      end
    end
  end

  context "admin" do
    let(:admin_token) { FactoryGirl.create(:admin_access_token) }

    it 'indexes users' do
      get users_path(format: :json), access_token: admin_token.token
      expect(response.status).to eq 200
    end

    it 'shows a user' do
      user = FactoryGirl.create(:user)
      get users_path(user.id, format: :json), access_token: admin_token.token
      expect(response).to be_success
    end
  end
end
