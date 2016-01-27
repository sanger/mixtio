class Api::V1::BatchesController < Api::V1::ApiController

  def show
    render json: Batch.find(params[:id])
  end

end
