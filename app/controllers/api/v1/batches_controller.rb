class Api::V1::BatchesController < ApplicationController

  def show
    render json: Batch.find(params[:id])
  end

end
