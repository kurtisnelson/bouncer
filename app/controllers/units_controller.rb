class UnitsController < ApplicationController
  before_action :authenticate!

  def index
    @units = Unit.all
    render json: @units
  end

  def show
    @unit = Unit.find(params[:id])
    render json: @unit
  end

  def create
    authenticate_device_scope_or_admin!
    @unit = Unit.new

    @unit.serial = params['units']['serial']

    if @unit.save
      render json: @unit
    else
      render json: {errors: @unit.errors}, status: :unprocessable_entity
    end
  end
end
