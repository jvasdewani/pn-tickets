class Issue < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :closed_by
  belongs_to :person
  belongs_to :department
  belongs_to :client
  belongs_to :contact
  belongs_to :task_list

  has_many :comments
  has_one :quote

   scope :active, -> { where.not(status: 'resolved')}
   scope :closed, -> { includes(:comments).where('comments.created_at' => (DateTime.now.utc.beginning_of_day..DateTime.now.utc.end_of_day)).where(status: 'resolved')}
   scope :opened, -> { includes(:comments).where('comments.created_at' => (DateTime.now.utc.beginning_of_day..DateTime.now.utc.end_of_day)).where(status: 'open')}


  accepts_nested_attributes_for :comments

  after_create :queue_notifications

  serialize :checklist, Hash

  def after_initialize
    self.checklist ||= {}
  end

  state_machine :status, :initial => :new do
    event :activate do
      transition all => :open
    end

    event :hold do
      transition all => :on_hold
    end

    event :resolve do
      transition all => :resolved
    end
  end

  state_machine :priority, :initial => :normal do
    event :alert do
      transition all => :critical
    end

    event :escalate do
      transition all => :high
    end

    event :descalate do
      transition all => :low
    end

    event :normalize do
      transition all => :normal
    end
  end

  def humane_status
    if response_time > 3600 && status == 'new'
      'overdue'
    else
      status
    end
  end

  def self.scorecard_for(comments, agent, status)
    if status == 10
      comments.inject(0) { |sum, i| sum + i.where(:_ns => 10).and(:person_id => agent._id).count }
    else
      comments.inject(0) { |sum, i| sum + i.where(:_ns.gte => 30).and(:person_id => agent._id).count }
    end
  end

  def issue_no
    id
  end

  def issue_time
    
    if status == 'resolved' || status == 'on_hold'
      issue_time_cache = self.issue_time_cache
    elsif comments.count >= 2 && comments.ordered.last._ns.to_i >= 20
      issue_time_cache = self.issue_time_cache.present? ? self.issue_time_cache + (Time.now - self.comments.ordered.last.created_at).to_i : 0 
    else
      issue_time_cache = 0
    end
    return issue_time_cache
  end

  def response_time
    if comments.count >= 2
      response_time_cache
    else
      comments.ordered.last.created_at.business_time_until(Time.now).to_i
    end
  end

  private

  def queue_notifications
    Notifications.perform_async(id) if checkid.nil?
  end
end
