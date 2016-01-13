class Api::V1::SuppliersController < ApplicationController

  def show
    render json: Supplier.find(params[:id])
  end

end
