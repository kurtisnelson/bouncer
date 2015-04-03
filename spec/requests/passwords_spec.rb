require 'request_helper'
describe 'Password requests' do
  it 'supports password reset' do
    email = Faker::Internet.email
    user = User.new
    user.email = email
    user.password = SecureRandom.hex
    user.confirm_email!
    expect(Mailer).to receive(:password_reset).with(user.id)
    post user_password_path, email: email
    expect{user.reload}.to change(user, :reset_password_token)
    expect(response).to be_success
  end
end
