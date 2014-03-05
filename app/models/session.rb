class Session
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :person

  attribute :username, String
  attribute :password, String

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
    # begin
      @person = Person.find_by_username(username)
      if @person
        authenticator = PasswordAuthenticator.new(@person)
        return authenticator.authenticate(password)
      end
    # rescue
    #   return false
    # end
  end
end
