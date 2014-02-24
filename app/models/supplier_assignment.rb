class SupplierAssignment < ActiveRecord::Base
  belongs_to :supplier_quote
  belongs_to :supplier
end
