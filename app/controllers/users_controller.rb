class UsersController < ApplicationController
  respond_to :html, :json

  def index
    authenticate_admin!
    @users = User.all
    respond_with @users
  end

  def confirm
    @user = User.find(params[:user_id])

    if params[:confirmation_token] == @user.email_confirmation_token
      @user.confirm_email!
      head :no_content
    elsif params[:confirmation_token] == @user.phone_verification_code
      @user.confirm_phone!
      head :no_content
    else
      head :bad_request
    end
  end

  def show
    if params[:id] == 'me'
      @user = current_user
    elsif current_service == 'cashier' || (current_user && current_user.super_admin?)
      @user = User.find(params[:id])
    else
      Rollbar.info("users/show denied", id: params[:id], service: current_service, user: current_user)
      raise UnauthorizedError
    end
    respond_with @user
  end

  def update
    authenticate!
    if params[:id]
      head :forbidden
      return
    else
      user = current_user
    end
    raise BadRequestError if params['user'].blank?
    user.phone = params["user"]["phone"] if params["user"]["phone"]
    user.name = params["user"]["name"] if params["user"]["name"]
    if user.save
      respond_with user
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  def admin
    authenticate_admin!
    @user = User.find(params[:user_id])
    @user.super_admin = true
    if @user.save
      flash[:notice] = "Admin granted"
    else
      flash[:error] = "Could not grant admin"
    end
    respond_with @user
  end
end
