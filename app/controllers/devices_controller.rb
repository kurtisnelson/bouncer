class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { current_user.super_admin? or doorkeeper_authorize! :device }, only: :create
  respond_to :json, :html

  def index
    if params[:serial]
      @devices = Device.where(serial: params[:serial], user_id: current_user.id)
    elsif current_user.super_admin?
      @devices = Device.all
    else
      @devices = Device.where(user_id: current_user.id)
    end
    respond_to do |format|
      format.json { render json: DevicesRepresenter.for_collection.prepare(@devices) }
      format.html
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
    if Device.where("serial = ? AND user_id != ?", serial, current_user.id).first
      respond_to do |f|
        f.html { render action: "new" }
        f.json { head :forbidden }
      end
    end
    @device = Device.new
    @device.user_id = current_user.id
    @device.serial = serial
    if @device.save
      Analytics.track(
        user_id: current_user.id,
        event: 'Created device',
        properties: { serial: serial }
      )
      respond_to do |format|
        format.html { redirect_to @device, notice: "Device was added" }
        format.json { render json: DevicesRepresenter.prepare(@device) }
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
    @token = @device.device_token
    return head :forbidden unless current_user.super_admin? || @device.user_id == current_user.id
    respond_to do |f|
      f.html
      f.json { render json: DevicesRepresenter.prepare(@device) }
    end
  end
end
