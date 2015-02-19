class UsersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  def admin
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

  def authenticate
    return true if current_service == 'cashier'
    authenticate_admin!
  end
end
