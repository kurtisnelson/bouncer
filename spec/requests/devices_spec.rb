require 'request_helper'

describe DevicesController do
  describe "POST /devices/register.json" do
    it "creates a new device" do
      expect do
        post register_devices_path(format: :json), {serial: "1234567890"}
      end.to change{Device.count}.by 1
      expect(response).to be_success
      expect(json['token']).to_not be nil
    end

    it "will not re-register existing device" do
        post register_devices_path(format: :json), {serial: "1234567890"}
        expect do
          post register_devices_path(format: :json), {serial: "1234567890"}
        end.to_not change{Device.count}
        expect(response.status).to eq 403
    end
  end
end
