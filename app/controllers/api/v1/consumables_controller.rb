class Api::V1::ConsumablesController < ApplicationController

  def show
    render json: Consumable.find_by_barcode(params[:barcode])
  end

end
