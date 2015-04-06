class Users::PasswordsController < ApplicationController
  respond_to :json, :html

  def index
    @user = User.find_by(email: params[:email])
    ## we actually expose a timing attack vuln here, if the user doesn't exist this request will be faster
    if @user
      @user.reset_password_token = SecureRandom.hex 12
      @user.save
      Mailer.password_reset @user.id
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
      respond_to do |f|
        f.json { head :no_content }
        f.html { render :success}
      end
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
    raise BadRequestError unless params[:users]
    params[:users]
  end

  def require_token
    raise UnauthenticatedError unless params[:reset_password_token]
  end
end
