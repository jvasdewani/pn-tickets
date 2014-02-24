class ReminderCategory < ActiveRecord::Base
  belongs_to :account
  has_many :reminders

  scope :ordered, -> { order(category_name: :asc) }
end
