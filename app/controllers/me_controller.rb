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
        f.json { respond_with user }
      end
    else
      head :bad_request
    end
  end
end
