class SupplierQuote < ActiveRecord::Base
  belongs_to :quote
  has_one :supplier_assignment
  has_one :supplier, through: :supplier_assignment

  accepts_nested_attributes_for :supplier_assignment
end
