class Batches::PrintController < ApplicationController

  # Save the label type ID when printing so it can be shown as default choice later
  before_action :save_label_id, :current_resource, only: [:create]

  # Disable editing once the batch has been printed
  after_action :set_editable_false, only: [:create]

  def create
    print_job = PrintJob.new(print_params)

    if print_job.execute!
      flash[:notice] = ["Your labels have been printed"]
    else
      flash[:error] = ["Your labels could not be printed"]
      print_job.errors.to_a.each do |error|
        flash[:error] << error
      end
    end

    redirect_to batch_path(current_resource)
  end

private

  def current_resource
    @batch ||= Batch.find(params[:id])
  end

  def print_params
    params.permit(:label_template_id, :printer).merge(batch: current_resource)
  end

  def save_label_id
    current_resource.consumable_type.update_column(:last_label_id, params[:label_template_id].to_i)
  end

  def set_editable_false
    current_resource.update_column(:editable, false)
  end

end