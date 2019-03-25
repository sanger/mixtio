class SuppliersController < ApplicationController

  before_action :suppliers, only: [:index]
  before_action :authenticate!, except: [:index]

  def index
    @archive = false
  end

  def archive_index
    @archive = true
    render :index
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      redirect_to suppliers_path, notice: "Supplier successfully created"
    else
      render :new
    end
  end

  def edit
    @supplier = current_resource
  end

  def update
    @supplier = current_resource
    if @supplier.update_attributes(supplier_params)
      redirect_to suppliers_path, notice: "Supplier successfully updated"
    else
      render :edit
    end
  end


  # PUT /suppliers/1/deactivate
  def deactivate
    @supplier = current_resource
    @supplier.deactivate!
    @supplier.create_audit(user: current_user, action: 'deactivate')
    redirect_back(fallback_location: suppliers_path)
  end

  # PUT /suppliers/1/activate
  def activate
    @supplier = current_resource
    @supplier.activate!
    @supplier.create_audit(user: current_user, action: 'activate')
    redirect_back(fallback_location: suppliers_archive_path)
  end

  def suppliers
    @suppliers ||= (@archive ? Supplier.inactive : Supplier.active).order_by_name.page(params[:page])
  end

private

  def current_resource
    Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :product_code)
  end

  helper_method :suppliers
end
