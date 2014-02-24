class MultiTicketEdit
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :ids, Array
  attribute :status, String
  attribute :message, String
  attribute :person, String

  validates_presence_of :status
  validates_presence_of :message

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

  private

  def persist!
    ids.each do |id|
      BulkTicket.perform_async(id, person, message, status)
    end
  end
end
