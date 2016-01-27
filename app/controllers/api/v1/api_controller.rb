class Api::V1::ApiController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { :message => e.message }, status: :not_found
  end

end