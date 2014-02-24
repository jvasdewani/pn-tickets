class Department < ActiveRecord::Base
  has_many :assignments
  has_many :people, through: :assignments
  has_many :issues

  scope :ordered, -> { order(:department_name) }
end
