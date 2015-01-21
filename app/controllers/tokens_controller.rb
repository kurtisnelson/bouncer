class TokensController < ApplicationController
  include Doorkeeper::Helpers::Controller

  def me
    if doorkeeper_token && doorkeeper_token.accessible?
      render json: User.find(doorkeeper_token.resource_owner_id), status: :ok
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_request)
      response.headers.merge!(error.headers)
      render json: error.body, status: error.status
    end
  end
end
