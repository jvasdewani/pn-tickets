class Report
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :start_date, Date, default: lambda { |page, attribute| Date.today - 1.month }
  attribute :end_date, Date, default: lambda { |page, attribute| Date.today }
  attribute :department, String
  attribute :client, String
  attribute :person, String
  attribute :product_type, String
  attribute :status, String

  validates_presence_of :start_date
  validates_presence_of :end_date

  def persisted?
    false
  end

  def save
    if valid?
      persist!
    else
      false
    end
  end

  def documents
    @search
  end

  private

  def persist!
    self.start_date = send(:start_date).beginning_of_day
    self.end_date = send(:end_date).end_of_day
    @search = Issue.select("DISTINCT issues.*").joins(:comments).where('comments.created_at' => (start_date..end_date))
    @search = @search.where(:department_id => department) unless department.blank?
    @search = @search.where(:client_id => client) unless client.blank?
    @search = @search.where(:person_id => person) unless person.blank?
    @search = @search.where(:product_type_id => product_type) unless product_type.blank?
    if status == 'active'
      @search = @search.where(["issues.status != ?", 'resolved'])
    else
      @search = @search.where(:status => status) unless status.blank?
    end
    @search.order(id: :desc)
  end
end
