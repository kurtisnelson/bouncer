require 'rails_helper'

describe Confirmable do
  let(:user) { FactoryGirl.create :unconfirmed_user }
  describe 'reset_confirmation!' do
    it 'sends email if not confirmed' do
      expect(user).to receive(:send_confirmation_instructions).once
      user.reset_confirmation!
    end

    it 'sends text if not confirmed' do
      expect(user).to receive(:send_verification_text).once
      user.reset_confirmation!
    end

    it 'sends nothing if fully confirmed' do
      user.confirm_email!
      user.confirm_phone!
      expect(user).to_not receive(:send_verification_text)
      expect(user).to_not receive(:send_confirmation_instructions)
      user.reset_confirmation!
    end
  end

  describe "send_confirmation_instructions" do
    it 'sends a msg to mandrill' do
      user
      expect_any_instance_of(Mailer).to receive(:send_mandrill_template)
      Sidekiq::Testing.inline! do
        user.send_confirmation_instructions
      end
    end
  end
end
