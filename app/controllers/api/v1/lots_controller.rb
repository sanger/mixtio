class Api::V1::LotsController < ApplicationController

  def show
    render json: Lot.find(params[:id])
  end

end
