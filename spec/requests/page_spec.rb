require 'request_helper'
describe 'Health page' do
  it "returns 200" do
    get root_path(format: :json)
    expect(response.status).to eq 200
  end
end
