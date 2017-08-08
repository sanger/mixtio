class BatchesController < ApplicationController

  before_action :authenticate!, except: [:index]
  before_action :current_resource, only: [:show, :print, :edit]

  # Save the label type ID when printing so it can be shown as default choice later
  before_action :save_label_id, only: [:print]

  # Disable editing once the batch has been printed
  after_action :set_editable_false, only: [:print]

  def index
  end

  def edit
    @batch_form = BatchForm.new(current_resource.attributes.symbolize_keys.merge(
      aliquots: @batch.get_aliquot_count, aliquot_volume: @batch.get_aliquot_volume,
      aliquot_unit: @batch.get_aliquot_unit, single_barcode: @batch.single_barcode?,
      ingredients: @batch.ingredients))
    unless current_resource.editable
      redirect_to batches_path
      flash[:error] = "This batch has already been printed, so can't be modified."
    end
  end

  def update
    @batch_form = BatchForm.new(batch_params.merge(current_user: current_user))
    if @batch_form.update(current_resource)
      redirect_to batch_path, notice: "Reagent batch successfully updated?"
    else
      redirect_to batch_path, error: "Error updating batch"
    end

    # delete all aliquots
    # update ingredients
    # update batch record
    # create new aliquots
  end

  def create
    @batch_form = BatchForm.new(batch_params.merge(current_user: current_user))
    if @batch_form.create
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
      flash[:notice] = ["Your labels have been printed"]
    else
      flash[:error] = ["Your labels could not be printed"]
      print_job.errors.to_a.each do |error|
          flash[:error] << error
      end
    end

    redirect_to batch_path(@batch)
  end

protected

  def batch_params
    params.require(:batch_form)
          .permit(:consumable_type_id, :consumable_name, :expiry_date,
                  :aliquots, :aliquot_volume, :aliquot_unit, :batch_volume,
                  :single_barcode,
                  :ingredients => [:consumable_type_id, :number, :kitchen_id]
          )
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

  def save_label_id
    @batch.consumable_type.update_column(:last_label_id, params[:label_template_id].to_i)
  end

  def set_editable_false
    @batch.update_column(:editable, false)
  end

  helper_method :batches
end
