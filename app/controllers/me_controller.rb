class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user
      render json: {user: current_user}, status: :ok
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end

  def update
    if current_user
      user = current_user
    elsif doorkeeper_token && doorkeeper_token.accessible?
      user = User.find(doorkeeper_token.resource_owner_id)
    else
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
