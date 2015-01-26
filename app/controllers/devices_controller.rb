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

  def register
    @device = Device.first_or_create(serial: params[:serial])
    return head :forbidden if @device && (@device.user_id != nil || @device.code != nil)

    @device.serial = params[:serial]
    @device.code = SecureRandom.hex(2)

    if @device.save
      render json: {token: @device.code}
    else
      head :bad_request
    end
  end

  def claim
    return unless params['code']
    @device = Device.where(code: params['code'], user_id: nil).first
    return redirect_to claim_devices_path, notice: "Already claimed" unless @device
    @device.user = current_user

    if @device.save
      redirect_to @device, notice: "Device claimed"
    else
      render action: "claim", notice: "Could not claim"
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

  def token
    @device = Device.find(params[:id])
    return head :forbidden unless @device.user_id == current_user.id
    render format: :json
  end
end
