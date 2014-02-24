class Contract < ActiveRecord::Base
  belongs_to :client
  has_many :service_assignments
  has_many :services, through: :service_assignments

  scope :expired, -> { where("end_date <= NOW() AND paid = false").order(:end_date) }
  scope :upcoming, -> { where("end_date <= DATE_ADD(NOW(), INTERVAL 28 DAY) AND end_date > NOW() AND paid = false").order(:end_date) }

  scope :active, -> { where(paid: false).order(:end_date) }
  scope :archived, -> { where(paid: true).order(:end_date) }

  scope :ordered, -> { order(end_date: :asc) }

  validates_presence_of :contract_name, :start_date, :end_date, :renewal_type, :value

  before_save :check_reset_logged_time

  accepts_nested_attributes_for :service_assignments, reject_if: :new_record?

  attr_accessor :add_to_time, :reset_time_info

  def renewal_type_humane
    case renewal_type
    when 'monthly'
      return "month"
    when 'quarterly'
      return "quarter"
    when 'annually'
      return "year"
    end
  end

  def hours_remaining
    return service_time_allocation - service_time_use
  end

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

  private

  def check_reset_logged_time
    if reset_time_info
      self.service_time_use = 0
    end
  end
end
