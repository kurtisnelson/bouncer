class UsersController < ApplicationController
  before_action :authenticate_admin!
  respond_to :html

  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: UsersRepresenter.for_collection.prepare(@users) }
      format.html
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |f|
      f.json { render json: UsersRepresenter.prepare(@user) }
      f.html
    end
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
