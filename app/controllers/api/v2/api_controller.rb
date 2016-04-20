class Api::V2::ApiController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_resource, only: [:show]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { :message => e.message }, status: :not_found
  end

  # GET /api/{plural_resource_name}
  def index
    plural_resource_name = "@#{resource_name.pluralize}"
    resources = resource_class.where(query_params)
                              .order(query_sort)
                              .page(page_params[:page])
                              .per(page_params[:page_size])

    instance_variable_set(plural_resource_name, resources)
    resource = instance_variable_get(plural_resource_name)
    render json: resource, include: includes, adapter: :json_api
  end

  # GET /api/{plural_resource_name}/1
  def show
    render json: get_resource, include: includes, adapter: :json_api
  end

  private

  def includes
    []
  end

  # Returns the resource from the created instance variable
  # @return [Object]
  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  # Returns the allowed parameters for searching
  # Override this method in each API controller
  # to permit additional parameters to search on
  # @return [Hash]
  def query_params
    {}
  end

  def query_sort
    params.permit(:sort)
    return {} if !params.has_key?(:sort)

    orders = { "-": :desc, "+": :asc }
    order  = "+"

    if ( ["-", "+"].include?(params[:sort][0]) )
      order = params[:sort].slice!(0)
    end

    return {} if !query_sort_params.include?(params[:sort])

    { params[:sort] => orders[order.to_sym] }
  end

  def query_sort_params
    ['created_at', 'updated_at']
  end

  # Returns the allowed parameters for pagination
  # @return [Hash]
  def page_params
    params.permit(:page, :page_size)
  end

  # The resource class based on the controller
  # @return [Class]
  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  # The singular name for the resource class based on the controller
  # @return [String]
  def resource_name
    @resource_name ||= self.controller_name.singularize
  end

  # Only allow a trusted parameter "white list" through.
  # If a single resource is loaded for #create or #update,
  # then the controller for the resource must implement
  # the method "#{resource_name}_params" to limit permitted
  # parameters for the individual model.
  def resource_params
    @resource_params ||= self.send("#{resource_name}_params")
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource(resource = nil)
    resource ||= resource_class.find(params[:id])
    instance_variable_set("@#{resource_name}", resource)
  end

end