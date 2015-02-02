class UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def admin
    @user = User.find(params[:user_id])
    @user.super_admin = true
    if @user.save
      redirect_to @user, notice: "Admin granted"
    else
      flash[:error] = "Could not grant admin"
      redirect_to @user
    end
  end
end
