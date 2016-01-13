class SuppliersController < ApplicationController

  before_action :suppliers, only: [:index]

  def index
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

private

  def suppliers
    @suppliers ||= Supplier.page(params[:page])
  end

  def current_resource
    Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name)
  end

  helper_method :suppliers
end
