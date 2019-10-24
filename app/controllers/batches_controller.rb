class BatchesController < ApplicationController

  before_action :authenticate!, except: [:index]
  before_action :current_resource, only: [:show, :update, :edit]

  def index
    @view_model = Batches::Index.new(filter_params)
  end

  def edit
    @batch_form = BatchForm.new
    unless current_resource.editable?
      redirect_to batches_path
      flash[:error] = "This batch has already been printed, so can't be modified."
    end
  end

  def update
    @batch_form = BatchForm.new(params: BatchFormParameters.new(update_batch_params))
    @batch = @batch_form.batch

    if @batch_form.save
      redirect_to batch_path(@batch), notice: "Reagent batch successfully updated!"
    else
      render :edit
    end
  end

  def create
    @batch_form = BatchForm.new(params: BatchFormParameters.new(batch_params))
    @batch = @batch_form.batch

    if @batch_form.save
      redirect_to batch_path(@batch), notice: "Reagent batch successfully created"
    else
      render :new
    end
  end

  def new
    @batch = Batch.new.tap { |b| b.sub_batches.build }
    @batch_form = BatchForm.new
  end

  def show
  end

protected

  def current_resource
    @batch ||= Batch.find(params[:id])
  end

  def batch_params
    @batch_params ||= params.require(:mixable)
      .permit(:consumable_type_id, :expiry_date,
              mixture_criteria: [:consumable_type_id, :number, :kitchen_id, :quantity, :unit_id],
              sub_batches: [:quantity, :volume, :unit, :barcode_type, :project_id]
      )
      .merge(user: current_user.user, action: params[:action])
      .tap do |batch_params|
        batch_params[:mixture_criteria] ||= []
        batch_params[:sub_batches] ||= []
        batch_params[:mixture_params] = batch_params[:mixture_criteria].map { |mxc| MixtureParameters.new(mxc) }
      end
  end

  def update_batch_params
    batch_params.merge(batch: current_resource)
  end

  def filter_params
    params.permit(:consumable_type_id, :created_after, :created_before, :page)
  end

end
