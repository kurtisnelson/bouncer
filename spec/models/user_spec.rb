require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  describe 'get_avatar' do
    it 'fetches the URL from facebook' do
      user.facebook_token = "CAAIPAZAqJPP8BAOaH8ryZAkYKZAAp2YSogbjxiYr9tpmo5EerZC7yBmexZAnoRaadakbHszxaZAvbE4jABWnZAZCscVZCJEFtirbkjSRv3Vi1Ozn7WsEUCZB7d9Qar7lMuZBJrZBXGw3nhfxuRlVL4lAH77n7GKCOV9pfoxkkp4vL7jkZCwLfFQzezhUAZCxM5VUMGMCKMT88t33f96GVHSj3CHm6WoimuXCdIEwRUJrBNiYzWAgZDZD"
      VCR.use_cassette 'facebook/avatar' do
        user.get_avatar
      end
      expect(user.image).to_not eq nil
    end
  end
end
