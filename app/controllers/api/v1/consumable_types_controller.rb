class Api::V1::ConsumableTypesController < Api::V1::ApiController

  def show
    render json: ConsumableType.find(params[:id])
  end

end
