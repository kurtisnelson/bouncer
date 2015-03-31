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
    elsif request.request_method == 'PUT' # resend confirmations
      authenticate_user!
      @user = User.find(params[:user_id])
      if current_user.super_admin? || @user.id == current_user.id
        @user.reset_confirmation
        head :no_content
      else
        raise UnauthorizedError
      end
    else
      head :bad_request
    end
  end

  def show
    authenticate!
    if params[:id] == 'me' && current_user
      @user = current_user
    else
      @user = User.find(params[:id])
    end

    if current_service == 'cashier' || (current_user && current_user.super_admin?) || @user.id == current_user.id
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

    raise BadRequestError if params['user'].blank?
    if params["user"]["phone"]
      user.phone = params["user"]["phone"]
      user.phone_verified_at = nil if user.phone_changed?
    end

    if params["user"]["email"]
      user.email = params["user"]["email"]
      user.email_verified_at = nil if user.email_changed?
    end
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
