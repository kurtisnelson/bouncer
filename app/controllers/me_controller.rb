class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    if @user = current_user
      render json: @user
    elsif @activation = current_activation
      render json: @activation
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end
end
