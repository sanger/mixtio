class Api::V1::ConsumableTypesController < ApplicationController

  def show
    render json: ConsumableType.find(params[:id])
  end

end
