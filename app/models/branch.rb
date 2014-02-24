class Branch < ActiveRecord::Base
  belongs_to :client
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :contacts, :allow_destroy => true, :reject_if => :new_record?
end
