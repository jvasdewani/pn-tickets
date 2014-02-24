class SuppliersController < ApplicationController
  before_filter :require_login!

  def create
    @id = params[:el_id]
    @supplier = Supplier.new supplier_params
  end

  private

  def supplier_params
    params.require(:supplier).permit(:id, :name)
  end
end
