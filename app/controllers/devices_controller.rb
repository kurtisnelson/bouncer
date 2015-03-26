class DevicesController < ApplicationController
  before_action :authenticate!
  respond_to :json, :html

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

  def claim
    authenticate_device_scope_or_admin!
    @device = Device.find(params["device_id"])
    raise UnauthorizedError if @device.user
    @device.user_id = current_user.id
    if @device.save
      render json: @device
    else
      render json: {errors: @device.errors}, status: :unprocessable_entity
    end
  end

  def unclaim
    @device = Device.find(params["device_id"])
    authenticate_admin_or_owner! @device
    @device.user_id = nil
    @device.device_tokens.destroy_all
    if @device.save
      respond_with @device
    else
      render json: {errors: @device.errors}, status: :unprocessable_entity
    end
  end

  def create
    authenticate_device_scope_or_admin!
    serial = device_json['serial'].tr('^A-Za-z0-9', '').downcase
    if Device.where("serial = ? AND user_id != ?", serial, current_user.id).count > 0
      Rollbar.info("devices/create forbidden", serial: serial, service: current_service, user: current_user)
      respond_to do |f|
        f.html { render action: "new" }
        f.json { head :forbidden }
      end
      return
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
        format.html { respond_with @device }
        format.json { render json: @device }
      end
    else
      Rollbar.info("Bad device", device: @device.to_json, error: @device.errors.to_json)
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
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
      if params['devices'].is_a? Array
        return params['devices'][0]
      else
        return params['devices']
      end
    elsif !params['device'].blank?
      return params['device']
    else
      raise BadRequestError
    end
  end

end
