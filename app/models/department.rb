class Department < ActiveRecord::Base
  has_many :assignments
  has_many :people, through: :assignments
  has_many :issues
  has_one :task_list

  scope :ordered, -> { order(:department_name) }
end
