require 'request_helper'
describe 'Password requests' do
  it 'supports password reset' do
    email = Faker::Internet.email
    user = User.new
    user.email = email
    user.password = SecureRandom.hex
    user.confirm_email!
    expect(Mailer).to receive(:password_reset).with(user.id)
    post reset_users_path, email: email
    expect{user.reload}.to change(user, :reset_password_token)
    expect(response).to be_success
  end

  it 'shows reset form' do
    token = SecureRandom.hex
    user = FactoryGirl.create(:user, reset_password_token: token)
    get user_reset_path(user, reset_password_token: token)
    expect(response.status).to eq 200
  end

  it 'allows reset' do
    token = SecureRandom.hex
    user = FactoryGirl.create(:user, reset_password_token: token)
    patch user_reset_path(user, reset_password_token: token), users: {password: "junk", password_confirmation: "junk"}
    expect(response.status).to eq 200
    user.reload
    expect(user.valid_password? "junk").to be true
  end
end
