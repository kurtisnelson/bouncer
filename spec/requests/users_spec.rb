require 'request_helper'

describe 'User Requests' do
  let(:user_token) { FactoryGirl.create(:access_token).token }
  let(:super_admin_token) { FactoryGirl.create(:admin_access_token).token }

  describe 'POST /users' do
    user_payload = {
      users: {
        email: "kurt@example.com",
        password: "12345678",
        password_confirmation: "12345678"
      }
    }

    it 'allows a user to register' do
      post users_path(format: :json), user_payload
      expect(response).to be_success
    end

    it 'leaves users unconfirmed' do
      post users_path(format: :json), user_payload
      user = User.find_by(email: user_payload[:users][:email])
      expect(user.confirmed?).to be false
    end

    it 'queues a confirmation email' do
      Sidekiq::Testing.fake!
      expect{post users_path(format: :json), user_payload}.to change{Sidekiq::Extensions::DelayedClass.jobs.size}.by 1
    end
  end

  describe 'GET /users' do
    it 'is unauthorized' do
      get users_path(format: :json), access_token: user_token
      expect(response.status).to eq 403
    end
    context 'admin' do
      it 'lists' do
        get users_path(format: :json), access_token: super_admin_token
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /users/:id' do
    context 'admin' do
      it 'shows the user if admin' do
        user = FactoryGirl.create(:user)
        get user_path(user.id, format: :json), access_token: super_admin_token
        expect(response).to be_success
        expect(json['users'].count).to eq 1
      end
    end

    context 'user' do
      it 'rejects' do
        user = FactoryGirl.create(:user)
        get user_path(user.id, format: :json), access_token: user_token
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST /users/me' do
    it "fails without a token" do
      post users_me_path(format: :json)
      expect(response.status).to eq 401
    end

    context 'valid token for user' do
      let!(:application) { FactoryGirl.create :application } # OAuth application
      let!(:user)        { FactoryGirl.create :user }
      let!(:access_token)       { FactoryGirl.create(:access_token, :application => application, :resource_owner_id => user.id) }

      it 'allows phone number to be updated' do
        number = "1234567890"
        post users_me_path(format: :json), access_token: access_token.token, user: {phone: number}
        expect(response).to be_success
        user.reload
        expect(user.phone).to eq number
      end

      it 'fails gracefully with bad params' do
        post users_me_path(format: :json), access_token: access_token.token, usersss: {}
        expect(response.status).to eq 400
      end
    end
  end

end
