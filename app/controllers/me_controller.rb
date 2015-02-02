class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    if @user = current_user
      render 'users/show'
    elsif @device = current_device
      render 'devices/show'
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
      @user = user
      render 'users/show'
    else
      head :bad_request
    end
  end
end
