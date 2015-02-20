class UsersController < ApplicationController
  respond_to :html, :json

  def index
    authenticate_admin!
    @users = User.all
    respond_with @users
  end

  def show
    if params[:id] == 'me'
      @user = current_user
    elsif current_service == 'cashier' || authenticate_admin!
      @user = User.find(params[:id])
    end
    respond_with @user
  end

  def update
    authenticate_user!
    if params[:id]
      head :forbidden
      return
    else
      user = current_user
    end
    user.phone = params["user"]["phone"]
    if user.save
      respond_with user
    else
      head :bad_request
    end
  end

  def admin
    authenticate_admin1
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
