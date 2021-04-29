class ConsumableTypesController < ApplicationController

  before_action :consumable_types, only: [:index]
  before_action :authenticate!, except: [:index]

  def index
    @archive = false
  end

  def archive_index
    @archive = true
    render :index
  end

  def create
    @consumable_type_form = ConsumableTypeForm.new(consumable_type_form_params)
    if @consumable_type_form.save
      redirect_to consumable_types_path, notice: "Consumable Type successfully created"
    else
      render :new
    end
  end

  def new
    @consumable_type_form = ConsumableTypeForm.new
  end

  def edit
    args = current_resource.attributes.slice('name', 'days_to_keep', 'storage_condition')
    args.merge!(mixture_criteria: current_resource.mixture_criteria, consumable_type: current_resource)
    @consumable_type_form = ConsumableTypeForm.new(args)
  end

  def update
    redirect_back(fallback_location: consumable_types_path) and return unless check_user_edit?
    @consumable_type_form = ConsumableTypeForm.new(consumable_type_form_edit_params)
    if @consumable_type_form.update
      redirect_to consumable_types_path, notice: "Consumable Type successfully updated"
    else
      render :edit
    end
  end

  # PUT /consumable_types/1/deactivate
  def deactivate
    redirect_back(fallback_location: consumable_types_path) and return unless check_user_edit?
    @consumable_type = current_resource
    @consumable_type.deactivate!
    @consumable_type.create_audit(user: current_user, action: 'deactivate')
    redirect_back(fallback_location: consumable_types_path)
  end

  # PUT /consumable_types/1/activate
  def activate
    redirect_back(fallback_location: consumable_types_path) and return unless check_user_edit?
    @consumable_type = current_resource
    @consumable_type.activate!
    @consumable_type.create_audit(user: current_user, action: 'activate')
    redirect_back(fallback_location: consumable_types_archive_path)
  end

  def consumable_types
    @consumable_types ||= (@archive ? ConsumableType.inactive : ConsumableType.active)
      .where(team: current_team)
      .order_by_name.page(params[:page])
  end

protected

  def check_user_edit?
    if current_resource && current_team != current_resource.team
      flash[:error] = "Only team #{current_resource.team.name} can alter this consumable type."
      return false
    end
    true
  end

  def consumable_type_params
    params.require(:mixable).permit(:name, :days_to_keep, :storage_condition,
        mixture_criteria: [:consumable_type_id, :kitchen_id, :quantity, :unit_id]
    )
  end

  def consumable_type_form_params
    consumable_type_params.merge(current_user: current_user)
  end

  def consumable_type_form_edit_params
    consumable_type_form_params.merge(consumable_type: current_resource)
  end

  def current_resource
    @current_resource ||= ConsumableType.find(params[:id]) if params[:id]
  end

  helper_method :consumable_types

end
