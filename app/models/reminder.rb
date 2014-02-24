class Reminder < ActiveRecord::Base
  belongs_to :client
  belongs_to :reminder_category

  scope :expired, -> { where("end_date <= NOW() AND paid = false").order(:end_date) }
  scope :upcoming, -> { where("end_date <= DATE_ADD(NOW(), INTERVAL 28 DAY) AND end_date > NOW() AND paid = false").order(:end_date) }

  scope :active, -> { where("paid = false").order(:end_date) }
  scope :archived, -> { where("paid = true").order(:end_date) }

  validates_presence_of :description, :end_date, :value

  def overdue?
    end_date <= Time.now && !paid
  end

  def upcoming?
    end_date <= Time.now + 28.days && end_date > Time.now && !paid
  end

  def class_state
    if overdue?
      "overdue"
    elsif upcoming?
      "upcoming"
    else
      "on_hold"
    end
  end
end
