class UsersController < ApplicationController
  respond_to :html, :json

  def index
    authenticate_admin!
    @users = User.all
    respond_with @users
  end

  def confirm
    @user = User.find(params[:user_id])

    if params[:confirmation_token] && params[:confirmation_token] == @user.email_confirmation_token
      @user.confirm_email!
      head :no_content
    elsif params[:confirmation_token] && params[:confirmation_token] == @user.phone_verification_code
      @user.confirm_phone!
      head :no_content
    else
      authenticate_user!
      raise UnauthorizedError unless current_user.super_admin? || @user.id == current_user.id
      @user.reset_confirmation!
      head :no_content
    end
  end

  def show
    authenticate!
    if params[:id] == 'me' && current_user
      @user = current_user
    else
      @user = User.find(params[:id])
    end

    if current_service == 'cashier' || current_service == 'barback'
      respond_with @user
    elsif current_user && (current_user.super_admin? || @user.id == current_user.id)
      respond_with @user
    else
      Rollbar.info("users/show denied", id: params[:id], service: current_service, user: current_user)
      raise UnauthorizedError
    end
  end

  def update
    authenticate!
    if params[:id] == current_user.id || current_user.super_admin?
      user = User.find(params[:id])
    elsif params[:id] == 'me' || params[:id].nil?
      user = current_user
    else
      raise UnauthorizedError
    end
    if user_params["phone"]
      user.phone = user_params["phone"]
      user.phone_verified_at = nil if user.phone_changed?
    end

    if user_params["email"]
      user.email = user_params["email"]
      user.email_verified_at = nil if user.email_changed?
    end
    user.name = user_params["name"] if user_params["name"]
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

  private

  def user_params
    return params['user'] if params['user'].present?
    return params['users'] if params['users'].present?
    raise BadRequestError
  end
end
