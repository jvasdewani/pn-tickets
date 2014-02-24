class SearchES
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :start_date, Date, default: lambda { |page, attribute| Date.today - 1.month }
  attribute :end_date, Date, default: lambda { |page, attribute| Date.today }
  attribute :ticket_no, String
  attribute :department, Integer
  attribute :client, Integer
  attribute :person, Integer
  attribute :product_type, Integer
  attribute :status, Integer
  attribute :priority, Integer
  attribute :limit, Integer

  validates_presence_of :start_date
  validates_presence_of :end_date

  attr_reader :issues

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
    @search.documents
  end

  private

  def persist!
    unless ticket_no.blank?
      @search = $search.index(:prime).search(query: { field: { id: ticket_no }})
    else
      puts start_date
      puts end_date
      s = status.to_i
      p = priority.to_i
      puts s
      query = { range: { 'comments.created_at' => { gte: start_date, lte: end_date } }, and: [] }
      query[:and] << { query: { field: { department_id: department } } } if department.present?
      query[:and] << { query: { field: { client_id: client } } } if client.present?
      query[:and] << { query: { field: { person_id: person } } } if person.present?
      query[:and] << { query: { field: { product_type: product_type } } } if product_type.present?
      unless s == 0
        if s.odd?
          s -= 1
          query[:and] << { query: { field: { status: s } } }
        else
          query[:and] << { query: { field: { 'comments.ns' => s } } } unless s == 99
          query[:and] << { query: { range: { 'comments.ns' => { gte: 20, lte: 40 } } } } if s == 98
        end
      else
        query[:and] << { query: { range: { status: { gte: 20, lte: 40 } } } }
      end
      unless p == 0
        query[:and] << { query: { field: { 'comments.np' => p } } }
      end
      puts query
      @search = $search.index(:prime).search(size: limit, filter: query)
    end
  end
end
