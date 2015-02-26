class DevicesController < ApplicationController
  before_action :authenticate!
  respond_to :json, :html
  responders :flash, :http_cache

  def index
    if params[:serial]
      @devices = Device.where(serial: params[:serial], user_id: current_user.id)
    elsif current_user && current_user.super_admin?
      @devices = Device.all
    elsif current_device
      @devices = [current_device]
    else
      @devices = Device.where(user_id: current_user.id)
    end
    respond_with @devices
  end

  def new
    @device = Device.new
  end

  def edit
    @device = Device.find(params["id"])
    authenticate_admin_or_owner! @device
  end

  def update
    @device = Device.find(params["id"])
    authenticate_admin_or_owner! @device

    @device.name = device_json["name"]
    if current_user && current_user.super_admin? && !device_json['user'].blank?
      @device.user_id = device_json['user']
    end

    if @device.save
      respond_to do |f|
        f.html { redirect_to @device, notice: "Device saved" }
        f.json { respond_with @device }
      end
    else
      render action: "edit"
    end
  end

  def remove
    @device = Device.find(params["device_id"])
    authenticate_admin_or_owner! @device
    @device.user_id = nil
    if @device.save
      redirect_to device_path(@device)
    else
      render action: "show"
    end
  end

  def destroy
    @device = Device.find(params["id"])
    authenticate_admin_or_owner! @device
    if @device.destroy
      redirect_to devices_path
    else
      render action: "show"
    end
  end

  def create
    doorkeeper_authorize! :device unless current_user.super_admin?
    serial = device_json['serial'].tr('^A-Za-z0-9', '').downcase
    if Device.where("serial = ? AND user_id != ?", serial, current_user.id).count > 0
      Rollbar.info("devices/create forbidden", serial: serial, service: current_service, user: current_user)
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
      respond_with @device
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
    authenticate_admin_or_owner! @device
    respond_with @device
  end

  private

  def device_json
    if !params['devices'].blank?
      return params['devices']
    elsif !params['device'].blank?
      return params['device']
    else
      raise BadRequestError
    end
  end

  def authenticate_admin_or_owner! device
    return if current_user && current_user.super_admin?
    return if current_user && current_user.id = device.user_id
    return if current_device && current_device.id = device.id
    raise UnauthorizedError
  end
end
