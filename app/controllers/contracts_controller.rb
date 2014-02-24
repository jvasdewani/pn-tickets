class ContractsController < ApplicationController
  before_filter :require_login!

  def index
    @contracts = Contract.ordered
  end

  def new
    @contract = Contract.new
    @contract.service_assignments.build
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to contracts_path
    else
      render :action => :new
    end
  end

  def edit
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])
    if @contract.update_attributes contract_params
      redirect_to contracts_path
    else
      render :edit
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    @contract.destroy
    redirect_to contracts_path
  end

  def invoiced
    @contract = Contract.find(params[:id])
    @contract.update_attribute :invoiced, true
    redirect_to :back
  end

  def paid
    @contract = Contract.find(params[:id])
    @contract.update_attribute :paid, true
    redirect_to :back
  end

  def update_time
    @contract = Contract.find(params[:id])
    new_time = @contract.contract_used_time + params[:contract][:add_to_time].to_i
    @contract.update_attribute :contract_used_time, new_time
    redirect_to contracts_path
  end

  private

  def contract_params
    params.require(:contract).permit(:id, :client_id, :contract_name, :start_date, :end_date, :value, :renewal_type, :service_time_allocation, :service_time_use, :invoiced, :paid, :service_assignments_attributes => [:id, :service_id, :contract_id, :_destroy])
  end
end
