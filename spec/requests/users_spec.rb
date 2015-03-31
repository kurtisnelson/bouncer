require 'request_helper'

describe 'User Requests' do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_token) { FactoryGirl.create(:access_token, resource_owner_id: user.id).token }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:super_admin_token) { FactoryGirl.create(:admin_access_token, resource_owner_id: admin.id).token }

  describe 'POST /users' do
    describe 'email signup' do
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
        expect(user.email_confirmed?).to be false
      end

      it 'queues a confirmation email' do
        Sidekiq::Testing.fake!
        expect{post users_path(format: :json), user_payload}.to change{Sidekiq::Extensions::DelayedClass.jobs.size}.by 1
      end
    end

    describe 'phone signup' do
      user_payload = {
        users: {
          phone: "4048675309",
          password: "12345678",
          password_confirmation: "12345678"
        }
      }

      it 'allows a user to register' do
        post users_path(format: :json), user_payload
        expect(response).to be_success
      end

      it 'leaves user unconfirmed' do
        post users_path(format: :json), user_payload
        user = User.find_by(phone: user_payload[:users][:phone])
        expect(user.phone_confirmed?).to be false
      end

      it 'queues a verification text' do
        Sidekiq::Testing.fake!
        expect{post users_path(format: :json), user_payload}.to change{Sidekiq::Extensions::DelayedClass.jobs.size}.by 1
      end
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
      it 'allows myself' do
        get user_path(user.id, format: :json), access_token: user_token
        expect(response.status).to eq 200
      end

      it 'rejects others' do
        other_user = FactoryGirl.create(:user)
        get user_path(other_user.id, format: :json), access_token: user_token
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET /users/:id/confirm' do
    let(:user) { FactoryGirl.create(:unconfirmed_user) }

    it 'confirms the user with the correct code' do
      get user_confirm_path(user.id, format: :json), confirmation_token: user.email_confirmation_token
      expect(response).to be_success
    end

    it 'does not confirm the user with the wrong code' do
      get user_confirm_path(user.id, format: :json), confirmation_token: SecureRandom.hex
      expect(response).to_not be_success
    end
  end

  describe 'PUT /users/:id/confirm' do
    let(:user) { FactoryGirl.create(:unconfirmed_user) }
    let(:user_token) { FactoryGirl.create(:access_token, resource_owner_id: user.id).token }

    it 'denies unauthenticated requests' do
      put user_confirm_path(user.id, format: :json)
      expect(response.status).to eq 401
    end

    it 'denies resending another user' do
      put user_confirm_path(admin.id, format: :json), access_token: user_token
      expect(response.status).to eq 403
    end

    it 'resets email token' do
      expect{put user_confirm_path(user.id, format: :json), access_token: user_token; user.reload}.to change(user, :email_confirmation_token)
      expect(response).to be_success
    end

    it 'resets phone token' do
      expect{put user_confirm_path(user.id, format: :json), access_token: user_token; user.reload}.to change(user, :phone_verification_code)
      expect(response).to be_success
    end

    it 'enqueues messages' do
      user
      expect{put user_confirm_path(user.id, format: :json), access_token: user_token}.to change{Sidekiq::Extensions::DelayedClass.jobs.size}.by 2
    end
  end

  describe 'GET /users/me' do
    it 'rejects when not authenticated' do
      get user_path('me', format: :json)
      expect(response.status).to eq 401
    end

    context 'user' do
      it 'shows info' do
        get user_path('me', format: :json), access_token: user_token
        expect(response).to be_success
      end
    end
  end

  describe 'PATCH /users/:id' do
    it "fails without a token" do
      patch user_path(user.id, format: :json)
      expect(response.status).to eq 401
    end

    context 'user' do
      it 'allows phone number to be updated but clears validity' do
        number = "1234567890"
        patch user_path(user.id, format: :json), access_token: user_token, user: {phone: number}
        expect(response).to be_success
        user.reload
        expect(user.phone).to eq number
        expect(user).to_not be_phone_confirmed
      end

      it 'allows email to be updated but clears validity' do
        email = "bob@example.com"
        patch user_path(user.id, format: :json), access_token: user_token, user: {email: email}
        expect(response).to be_success
        user.reload
        expect(user.email).to eq email
        expect(user).to_not be_email_confirmed
      end
    end

    context 'me' do
      it 'allows phone number to be updated' do
        number = "1234567890"
        patch user_path('me', format: :json), access_token: user_token, user: {phone: number}
        expect(response).to be_success
      end
    end
  end
end
