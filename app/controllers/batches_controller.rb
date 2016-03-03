class BatchesController < ApplicationController

  before_action :authenticate!, except: [:index]
  before_action :current_resource, only: [:show, :print]

  def index
  end

  def create
    @batch_form = BatchForm.new(batch_params.merge(current_user: current_user))
    if @batch_form.save
      redirect_to batch_path(@batch_form.batch), notice: "Reagent batch successfully created"
    else
      render :new
    end
  end

  def new
    @batch_form = BatchForm.new
  end

  def show
  end

  def print
    print_job = PrintJob.new(print_params.merge(:batch => current_resource))

    if print_job.execute!
      flash[:notice] = "Your labels have been printed"
    else
      flash[:error] = "Your labels could not be printed"
    end

    redirect_to batch_path(@batch)
  end

protected

  def batch_params
    params.require(:batch_form)
          .permit(:consumable_type_id, :consumable_name, :expiry_date,
                  :aliquots, :volume, :unit, :ingredients => [:consumable_type_id, :number, :kitchen_id])
  end

  def batches
    @batches ||= Batch.order_by_created_at.page(params[:page])
  end

  def print_params
    params.permit(:label_template_id, :printer)
  end

  def current_resource
    @batch = Batch.find(params[:id])
  end

  helper_method :batches
end
