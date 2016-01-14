class Api::V1::SuppliersController < Api::V1::ApiController

  def show
    render json: Supplier.find(params[:id])
  end

end
