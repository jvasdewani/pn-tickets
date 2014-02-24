class Supplier < ActiveRecord::Base
  has_many :supplier_assignments
  has_many :supplier_quotes, through: :supplier_assignments

  scope :ordered, -> { order(:name) }
end
