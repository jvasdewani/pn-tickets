class PaymentOrdersController < ApplicationController
  before_filter :require_login!

  def index
    @payment_orders = PaymentOrder.active
  end

  def new
    @payment_order = PaymentOrder.new
  end

  def create
    @payment_order = PaymentOrder.new(params[:payment_order])
    if @payment_order.save
      redirect_to payment_orders_path
    else
      render :action => :new
    end
  end

  def edit
    @payment_order = PaymentOrder.find(params[:id])
  end

  def update
    @payment_order = PaymentOrder.find(params[:id])
    if @payment_order.update_attributes(params[:payment_order])
      redirect_to payment_orders_path
    else
      render :action => :edit
    end
  end

  def destroy
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.destroy
    redirect_to payment_orders_path
  end

  def received
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.supplier_confirmation!
    redirect_to :back
  end

  def raised
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.raise_invoice!
    redirect_to :back
  end

  def fulfilled
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.fulfill!
    redirect_to :back
  end

  def invoiced
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.supplier_invoice!
    redirect_to :back
  end

  def client_paid
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.client_payment_received!
    redirect_to :back
  end

  def supplier_paid
    @payment_order = PaymentOrder.find(params[:id])
    @payment_order.supplier_payment_received!
    redirect_to :back
  end
end
