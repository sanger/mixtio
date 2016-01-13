class BatchesController < ApplicationController

  def index
  end

  def create
    @batch_form = BatchForm.new(batch_params)
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
          .permit(:consumable_type_id, :consumable_name,
                  :lot_name, :supplier_id, :expiry_date, :arrival_date,
                  :aliquots, :lots => [:consumable_type_id, :name, :supplier_id])
  end

  def batches
    @batches ||= Batch.order_by_created_at.page(params[:page])
  end

  helper_method :batches
end
