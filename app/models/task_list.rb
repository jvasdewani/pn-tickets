class TaskList < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :issues
  belongs_to :client

  accepts_nested_attributes_for :tasks, :allow_destroy => true, :reject_if => :new_record?
end
