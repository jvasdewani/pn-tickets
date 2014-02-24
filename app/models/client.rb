class Client < ActiveRecord::Base
  belongs_to :health_check_department
  belongs_to :health_check_person

  has_many :branches, dependent: :destroy
  has_many :contacts, through: :branches
  has_many :contracts
  has_many :payments, through: :contracts
  has_many :reminders
  has_many :payment_orders
  has_many :quotes
  has_many :task_lists

  validates_presence_of :company

  scope :ordered, -> { order(company: :asc) }
  scope :active, -> { where(active_client: true) }

  accepts_nested_attributes_for :branches, :allow_destroy => true, :reject_if => :new_record?

  def check_date
    date = health_check_date.to_s.split('-').reverse.join('/') if health_check_date.present?
  end

  def check_date=(date)
    self.health_check_date = Date.parse(date.split('/').reverse.join('-')) if date.present?
  end
end
