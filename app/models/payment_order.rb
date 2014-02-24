class PaymentOrder < ActiveRecord::Base
  belongs_to :client

  scope :active, where("state != 'supplier_paid'").order(:created_at)
  before_create :set_po_number

  def set_po_number
    max_po = self.class.maximum(:po_number)
    self.po_number = max_po.to_i + 1
  end

  state_machine :state, :initial => :new do
    event :supplier_confirmation do
      transition :new => :supplier_confirmed
    end

    event :raise_invoice do
      transition :supplier_confirmed => :invoice_raised
    end

    event :fulfill do
      transition :invoice_raised => :order_fulfilled
    end

    event :supplier_invoice do
      transition :order_fulfilled => :supplier_invoiced
    end

    event :client_payment_received do
      transition :supplier_invoiced => :client_paid
    end

    event :supplier_payment_received do
      transition :client_paid => :supplier_paid
    end
  end
end
