class IssuesController < ApplicationController
  before_filter :require_login!

  def index
    session[:referer] = nil


if params[:department_id].present?
  @department = Department.find(params[:department_id])
  @count = @department.issues.active.count
  @issues = @department.issues.active.page params[:page]
else
    case params[:issues_status]
      when 'opened'
        @issues = Issue.opened.page params[:page]
      when 'closed'
        @issues = Issue.closed.page params[:page]
      else
        @issues = Issue.active.order('is_order Asc, id Desc').page params[:page]
    end
end


    @count  = @issues.count
    @bulk_edit = MultiTicketEdit.new if current_person.admin?
    @search = Search.new
  end

  def issues_with_current_status
  end  

  def new
    session[:referer] = request.referer if session[:referer].nil?
    @issue = Issue.new
    @issue.comments.build
  end

  def create
    @issue = Issue.new(issue_params)
    #render :text => params.inspect and return false
    if @issue.save
      CacheValue.perform_async(@issue.id)
      redirect_to issue_path(@issue)
    else
      render :action => :new
    end
  end

  def show
    session[:referer] = request.referer if session[:referer].nil?
    @issue = Issue.find(params[:id])
    @comment = Comment.where(:issue_id => params[:id]).last
    #return render text: @comment._ns
  end

  def show_ticket
    session[:referer] = request.referer if session[:referer].nil?
    @issue = Issue.find(params[:id])
  end
 
  def update
    @issue = Issue.find(params[:id])
    #return render text: params[:_ps]
    if @issue.update_attributes(issue_params)
      status = update_issue_status(issue_params)
      @issue.update_attributes(:status => status[:status_value], :is_order => status[:order_value], issue_time_cache: params[:issue_time]) 

      if @issue.checkid.present?
        HTTParty.get("https://www.systemmonitor.co.uk/api?apikey=c18fb67dd0fa6bd0d8d8880d4d56a759&service=clear_check&checkid=#{@issue.checkid}")
      end
      if @issue.quote.present?
        CheckQuote.perform_async(@issue.id)
      end
      CacheValue.perform_async(@issue.id)
      redirect_to issue_path(@issue)
    else
      logger.fatal @issue.errors.messages
      render :action => :show
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to issues_path
  end

  def widescreen
    @agents = Person.scoreboard.ordered
    render :layout => 'widescreen'
  end

  def weekly
    @issues = Issue.where(:created_at.gte => Time.now.beginning_of_week).where(:created_at.lte => Time.now.end_of_week)
    @closed = Issue.where(:created_at.gte => Time.now.beginning_of_week).where(:created_at.lte => Time.now.end_of_week).where(:status_cache => 10)
    respond_to do |format|
      format.pdf do
        pdf = SummaryPdf.new(@issues, @closed, "Summary for week beginning #{Time.now.beginning_of_week.strftime('%d/%m/%Y')}", view_context)
        send_data pdf.render, :filename => 'report.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end

  def monthly
    @issues = Issue.where(:created_at.gte => Time.now.beginning_of_month).where(:created_at.lte => Time.now.end_of_month)
    @closed = Issue.where(:created_at.gte => Time.now.beginning_of_month).where(:created_at.lte => Time.now.end_of_month).where(:status_cache => 10)
    respond_to do |format|
      format.pdf do
        pdf = SummaryPdf.new(@issues, @closed, "Summary for month beginning #{Time.now.beginning_of_month.strftime('%d/%m/%Y')}", view_context)
        send_data pdf.render, :filename => 'report.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end

  def list_ticket
    person_id = current_person.id
    clients = Client.where(people_id: person_id).first
    @client_id = clients.id
    if request.post?
	    unless params[:search][:ticket_no].blank?
	      issues = Issue.where id: params[:search][:ticket_no], client_id: clients.id
              @issues = issues.page params[:page]
	    else
	     start_date = params[:search][:start_date]
       end_date = params[:search][:end_date]
	     
	     issues = Issue.select("DISTINCT issues.*").includes(:comments).where('comments.created_at' => (start_date..end_date))
       issues = issues.where(client_id: clients.id)
	     issues = issues.where(:department_id => params[:search][:department]) unless params[:search][:department].blank?
	     issues = issues.where(:product_type_id => params[:search][:product_type]) unless params[:search][:product_type].blank?
	     issues = issues.where(:status => params[:search][:status]) unless params[:search][:status].blank?
	     @issues = issues.page params[:page]
	    end
    else
      @issues = Issue.where(client_id: clients.id).page params[:page]
    end
    @search_client = Search.new(params[:search])
  end

  private

  def issue_params
    params.require(:issue).permit!
  end
  
  def update_issue_status(issue_params)
    status = issue_params['comments_attributes'].to_a
    if status[0][1]['_ns'] == '10'
      status_value = 'resolved'
      order_value = '5'
    elsif status[0][1]['_ns'] == '20'
      status_value = 'on_hold'
      order_value = '4'
    elsif status[0][1]['_ns'] == '30'
      status_value = 'open'
      order_value = '2'
    end
    arr = {:status_value => status_value, :order_value => order_value}
  end
end
