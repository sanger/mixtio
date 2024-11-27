class Batches::SupportController < ApplicationController

  def show
    @batch_id = params[:id]
    @support_url = Rail.configuration.support_url
    @support_email = Rails.configuration.support_email
  end

end
