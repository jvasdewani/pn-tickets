class ProductTypesController < ApplicationController
  before_filter :require_login!

  def new
    @product = ProductType.new
  end

  def create
    @product = ProductType.new product_type_params
    if @product.save
      redirect_to settings_path
    else
      render :new
    end
  end

  def edit
    @product = ProductType.find(params[:id])
  end

  def update
    @product = ProductType.find(params[:id])
    if @product.update_attributes product_type_params
      redirect_to settings_path
    else
      render :edit
    end
  end

  def destroy
    @product = ProductType.find(params[:id])
    @product.destroy
    redirect_to settings_path
  end

  private

  def product_type_params
    params.require(:product_type).permit(:id, :name)
  end
end
