class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    if user = current_user
      render json: {user: user}, status: :ok
    elsif device = current_device
      render json: {device: device}, status: :ok
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
      render json: {user: user}, status: :ok
    else
      head :bad_request
    end
  end
end
