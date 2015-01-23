require 'request_helper'

describe Doorkeeper::TokensController do
  describe 'POST /oauth/token' do
    it 'accepts an assertion grant' do
      allow_any_instance_of(User).to receive(:get_avatar)
      VCR.use_cassette 'facebook/token' do
        post oauth_token_path, {"grant_type"=>"assertion", "assertion"=>"valid"}
      end
      expect(response).to be_success
    end

    it 'rejects an invalid token' do
      VCR.use_cassette 'facebook/invalid_token' do
        post oauth_token_path, {"grant_type"=>"assertion", "assertion"=>"bad"}
      end
      expect(response.status).to eq 401
    end
  end
end
