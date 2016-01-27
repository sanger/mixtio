class Api::V1::ConsumablesController < Api::V1::ApiController

  def show
    render json: Consumable.find_by_barcode!(params[:barcode])
  end

end
