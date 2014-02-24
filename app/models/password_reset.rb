class PasswordReset
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :password, String

  validates_presence_of :password
  validates_confirmation_of :password

  def user=(user)
    @user = user
  end

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
    if @user
      @user.update_attributes password: password, password_confirmation: password_confirmation
    else
      return false
    end
  end
end
