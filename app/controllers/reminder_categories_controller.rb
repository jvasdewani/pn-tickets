class ReminderCategoriesController < ApplicationController
  before_filter :require_login!

  def show
    @category = @current_account.reminder_categories.find(params[:id])
    @overdue = @category.reminders.expired
    @upcoming = @category.reminders.upcoming
  end

  def new
    @reminder = ReminderCategory.new
  end

  def create
    @reminder = ReminderCategory.new reminder_category_params
    if @reminder.save
      redirect_to settings_path
    else
      render :new
    end
  end

  def edit
    @reminder = ReminderCategory.find(params[:id])
  end

  def update
    @reminder = ReminderCategory.find(params[:id])
    if @reminder.update_attributes reminder_category_params
      redirect_to settings_path
    else
      render :edit
    end
  end

  def destroy
    @reminder = ReminderCategory.find(params[:id])
    @reminder.destroy
    redirect_to settings_path
  end

  private

  def reminder_category_params
    params.require(:reminder_category).permit(:id, :category_name)
  end
end
