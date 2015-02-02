require 'rails_helper'

describe UsersController do
  describe 'GET devices' do
    context 'admin token' do
      before do
        login_admin
      end
      it 'lists the users' do
        FactoryGirl.create(:user)
        get :index
        expect(response).to be_success
        expect(assigns(:users).size).to eq 2
      end
    end

    context 'plain user' do
      it 'is unauthorized' do
        login_user
        get :index
        expect(response).to_not be_success
      end
    end
    context 'no auth' do
      it 'is unauthorized' do
        get :index
        expect(response).to_not be_success
      end
    end
  end
end
