class ProductType < ActiveRecord::Base
  has_many :issues

  scope :ordered, -> { order(name: :asc) }
end
