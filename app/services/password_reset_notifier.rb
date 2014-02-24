class PasswordResetNotifier
  attr_reader :user

  def initialize(email_address)
    @user = Identity.where(email_address: email_address).first
  end

  def notified?
    @user && notified_user?
  end

  private

  def notified_user?
    Notifications.delay.reset_password_email(@user.guid)
  end
end
