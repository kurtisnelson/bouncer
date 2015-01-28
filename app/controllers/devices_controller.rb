class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { doorkeeper_authorize! :device }, only: :create

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
    if current_user.super_admin? && !params['device']['user'].blank?
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
    serial = params['device']['serial'].tr('^A-Za-z0-9', '').downcase
    @device = Device.where(serial: serial).first
    return head :forbidden if Device.where(serial: serial, :user_id.ne => current_user.id).first
    @device = Device.new
    @device.user_id = current_user.id
    @device.serial = serial
    if @device.save
      respond_to do |format|
        format.html { redirect_to @device, notice: "Device was added" }
        format.json { render action: "show" }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { head :bad_request }
      end
    end
  end

  def show
    @device = Device.find(params[:id])
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
  end
end
