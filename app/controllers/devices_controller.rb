class DevicesController < ApplicationController
  before_filter :authenticate_user!, except: [:register]

  def index
    if params[:serial]
      @devices = Device.where(serial: params[:serial], user_id: current_user.id)
    elsif current_user.super_admin?
      @devices = Device.all
    else
      @devices = Device.where(user_id: current_user.id)
    end
  end

  def new
    @device = Device.new
  end

  def edit
    @device = Device.find(params["id"])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
  end

  def update
    @device = Device.find(params["id"])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
    @device.name = params['device']["name"]
    @device.serial = params['device']["serial"]
    if current_user.super_admin? && params['device']['user']
      @device.user_id = params['device']['user']
    end

    if @device.save
      redirect_to @device, notice: "Device saved"
    else
      render action: "edit"
    end
  end

  def remove
    @device = Device.find(params["device_id"])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
    @device.user_id = nil
    if @device.save
      redirect_to device_path(@device)
    else
      render action: "show"
    end
  end

  def destroy
    @device = Device.find(params["id"])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
    if @device.destroy
      redirect_to devices_path
    else
      render action: "show"
    end
  end

  def create
    @device = Device.new
    @device.user = current_user
    @device.serial = params['device']['serial'].tr('^A-Za-z0-9', '').downcase
    if @device.save
      redirect_to @device, notice: "Device was added"
    else
      render action: "new"
    end
  end

  def show
    @device = Device.find(params[:id])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
  end
end