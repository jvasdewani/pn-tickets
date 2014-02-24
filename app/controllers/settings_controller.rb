class SettingsController < ApplicationController
  before_filter :require_login!

  def index
    @reminders = ReminderCategory.ordered
    @products = ProductType.ordered
    @services = Service.ordered
  end
end
