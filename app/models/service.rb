class Service < ActiveRecord::Base
  has_many :service_assignments
  scope :ordered, -> { order(name: :asc) }
end
