class RemindersController < ApplicationController
  before_filter :require_login!

  def index
    @reminders = Reminder.active
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    if @reminder.save
      redirect_to reminders_path
    else
      render :action => :new
    end
  end

  def edit
    @reminder = Reminder.find(params[:id])
  end

  def update
    @reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(reminder_params)
      redirect_to reminders_path
    else
      render :action => :edit
    end
  end

  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy
    redirect_to reminders_path
  end

  def paid
    @reminder = Reminder.find(params[:id])
    @reminder.update_attribute :paid, true
    redirect_to :back
  end

  def invoiced
    @reminder = Reminder.find(params[:id])
    @reminder.update_attribute :invoiced, true
    redirect_to :back
  end

  private

  def reminder_params
    params.require(:reminder).permit(:id, :client_id, :reminder_category_id, :description, :end_date, :value, :paid, :invoiced)
  end
end
