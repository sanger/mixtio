class BatchesController < ApplicationController

  before_action :authenticate!, except: [:index]

  def index
  end

  def create
    @batch_form = BatchForm.new(batch_params.merge(current_user: current_user))
    if @batch_form.save
      redirect_to root_path, notice: "Reagent batch successfully created"
    else
      render :new
    end
  end

  def new
    @batch_form = BatchForm.new
  end

protected

  def batch_params
    params.require(:batch_form)
          .permit(:consumable_type_id, :consumable_name, :expiry_date,
                  :aliquots, :ingredients => [:consumable_type_id, :number, :kitchen_id])
  end

  def batches
    @batches ||= Batch.order_by_created_at.page(params[:page])
  end

  helper_method :batches
end
