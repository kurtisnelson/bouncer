class MeController < ApplicationController
  before_action :authenticate_user!
  respond_to :json, :html

  def show
    if @user = current_user
      respond_with @user
    elsif @device = current_device
      respond_with @device
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end
end
