class MeController < ApplicationController
  before_action :authenticate_user!
  represents :json, Users

  def show
    if @user = current_user
      respond_with @user
    elsif @device = current_device
      render json: DevicesRepresenter.prepare(@device)
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end

  def update
    user = current_user
    unless user
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
      return
    end
    user.phone = params["user"]["phone"]
    if user.save
      respond_with user
    else
      head :bad_request
    end
  end
end
