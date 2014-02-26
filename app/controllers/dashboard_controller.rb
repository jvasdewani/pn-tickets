class DashboardController < ApplicationController
  before_filter :require_login!

  def index
    @issues = current_person.issues.active  
    if current_person.client?
      redirect_to list_ticket_path
    end
    session[:referer] = nil
    @issues = current_person.issues.active
    @bulk_edit = MultiTicketEdit.new if current_person.admin?
    @search = Search.new
  end

  def issues_status
    case params[:issues_status]
      when 'opened'
        redirect_to searches_path() 
      when 'closed'
        redirect_to searches_path(start_date: DateTime.now.utc.beginning_of_day, end_date: DateTime.now,status: 'resolved') 
      else
#        redirect_to controller:'issues' , action: 'list_ticket'
    end
  end  

end
