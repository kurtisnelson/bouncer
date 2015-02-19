require 'request_helper'

describe 'User requests' do
  let(:user_token) { FactoryGirl.create(:access_token) }

  it 'fails for plain users' do
    get users_path(format: :json), access_token: user_token.token
    expect(response.status).to eq 403
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
