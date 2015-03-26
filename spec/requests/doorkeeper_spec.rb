require 'request_helper'

describe Doorkeeper::TokensController do
  describe 'POST /oauth/token' do
    it 'accepts a username and password' do
      password = SecureRandom.hex
      user = User.new
      user.email = Faker::Internet.email
      user.password = password
      user.confirm_email!
      post oauth_token_path, {grant_type: "password", email: user.email, password: password}
      expect(response.status).to eq 200
    end

    it 'accepts a phone and password' do
      password = SecureRandom.hex
      user = User.new
      user.phone = Faker::PhoneNumber.cell_phone
      user.password = password
      user.confirm_phone!
      post oauth_token_path, {grant_type: "password", phone: user.phone, password: password}
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
