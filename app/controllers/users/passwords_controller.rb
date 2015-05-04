class Users::PasswordsController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(email: params[:email])
    ## we actually expose a timing attack vuln here, if the user doesn't exist this request will be faster
    uri = ENV['PASSWORD_RESET_URL']
    uri = params[:url] if params[:url]
    begin
      uri = URI.parse uri
    rescue URI::InvalidURIError
      raise BadRequestError
    end
    if @user
      @user.reset_password_token = SecureRandom.hex 12
      @user.save
      Mailer.password_reset @user.id, uri
    else
      logger.warn "User does not exist, will not reset"
    end
    head :no_content
  end

  def update
    @user = User.find(params[:user_id])
    token = params[:reset_password_token]
    raise UnauthorizedError unless @user.reset_password_token == token
    raise BadRequestError unless user_params[:password] == user_params[:password_confirmation]
    @user.password = user_params[:password]
    if @user.save
      head :no_content
    else
      raise BadRequestError
    end
  end

  def show
    @user = User.find(params[:user_id])
    @token = params[:reset_password_token]
    raise UnauthorizedError unless @user.reset_password_token == @token
  end

  private

  def user_params
    if !params[:user].blank?
      params[:user]
    elsif !params[:users].blank?
      params[:users]
    else
      raise BadRequestError
    end
  end

  def require_token
    raise UnauthenticatedError unless params[:reset_password_token]
  end
end
