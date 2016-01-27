class Api::V1::LotsController < Api::V1::ApiController

  def show
    render json: Lot.find(params[:id])
  end

end
