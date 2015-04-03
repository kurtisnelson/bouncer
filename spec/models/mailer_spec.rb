require 'rails_helper'

describe Mailer do
  let(:user) { FactoryGirl.create(:user) }
  describe "#password_reset" do
    it "sends via mandrill" do
      VCR.use_cassette 'mandrill/password_reset' do
        Mailer.password_reset user.id
      end
    end
  end

  describe '#confirmation' do
    it 'sends via mandrill' do
      VCR.use_cassette 'mandrill/confirmation' do
        Mailer.confirmation user.id
      end
    end
  end
end
