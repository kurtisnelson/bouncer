require 'rails_helper'

describe DevicesController do
  describe 'GET devices' do
    context 'logged in' do
      before do
        login_user
      end
      
      it 'returns a list of devices owned by the user' do
        FactoryGirl.create(:device, user: @user)
        FactoryGirl.create(:device)
        get :index
        expect(response).to be_success
        expect(assigns(:devices).size).to eq 1
      end
    end
  end
end
