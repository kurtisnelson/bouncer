class ActivationsController < ApplicationController
  before_action :authenticate!
  respond_to :json

  def index
    if current_user && current_user.super_admin?
      @activations = Activation.page(page).per(params[:per_page])
    elsif current_activation
      @activations = [current_activation]
    else
      @activations = Activation.where(user_id: current_user.id).page(page).per(params[:per_page])
    end
    render_json_api @activations
  end

  def create
    authenticate_device_scope_or_admin!
    @activation = Activation.new
    @activation.unit = unit_from params
    @activation.device_id = params['activations']['device']
    @activation.user_id = current_user.id
    if @activation.save
      @activation.issue_token
      render json: @activation
      Analytics.track(
        user_id: current_user.id,
        event: 'Activated unit',
        properties: { serial: @activation.unit.serial }
      )
    else
      render json: {errors: @activation.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @activation = Activation.find(params[:id])
    authenticate_admin_or_owner! @activation
    @activation.tokens.destroy_all
    if @activation.destroy
      head :no_content
    else
      render json: {errors: @activation.errors}, status: :unprocessable_entity
    end
  end

  def show
    @activation = Activation.find(params[:id])
    @token = @activation.token
    authenticate_admin_or_owner! @activation
    render_json_api @activation
  end

  private

  def unit_from params
    if params['activations']["unit"]
      @unit = Unit.find(params['activations']["unit"])
    else params['activations']['serial']
      @unit = Unit.find_or_create_by(serial: params['activations']['serial'])
    end
    @unit
  end
end
