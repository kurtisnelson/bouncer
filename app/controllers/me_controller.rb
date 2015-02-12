class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    if @user = current_user
      render json: UsersRepresenter.prepare(@user)
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
      respond_to do |f|
        f.html { redirect_to user, notice: "User saved" }
        f.json { render json: UsersRepresenter.prepare(user) }
      end
    else
      head :bad_request
    end
  end
end
