require 'request_helper'

describe Doorkeeper::TokensController do
  describe 'POST /oauth/token' do
    it 'accepts a username and password' do
      password = SecureRandom.hex
      user = User.new
      user.email = Faker::Internet.email
      user.password = password
      user.confirm!
      user.save!
      post oauth_token_path, {grant_type: "password", username: user.email, password: password}
      expect(response.status).to eq 200
    end
    it 'accepts an assertion grant' do
      VCR.use_cassette 'facebook/token' do
        post oauth_token_path, {"grant_type"=>"assertion", "assertion"=>"valid"}
      end
      expect(response.status).to eq 200
    end

    it 'rejects an invalid token' do
      VCR.use_cassette 'facebook/invalid_token' do
        post oauth_token_path, {"grant_type"=>"assertion", "assertion"=>"bad"}
      end
      expect(response.status).to eq 401
    end
  end
end
