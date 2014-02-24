class QuotesController < ApplicationController
  before_filter :require_login!, except: [ :client_view, :client_login, :client_approve ]
  before_filter :require_password!, only: [ :client_view, :client_approve ]

  def index
    if params[:client_id]
      @client = Client.find params[:client_id]
      @quotes = @client.quotes.ordered.active.page params[:page]
    else
      @quotes = Quote.ordered.active.page params[:page]
    end
  end

  def new
    @quote = Quote.new
    @quote.supplier_quotes.build if @quote.supplier_quotes.count == 0
  end

  def create
    @quote = Quote.new quote_params
    if @quote.save
      redirect_to @quote
    else
      render :new
    end
  end

  def show
    @quote = Quote.find params[:id]
  end

  def update
    @quote = Quote.find params[:id]
    if @quote.update_attributes quote_params
      redirect_to @quote
    else
      render :show
    end
  end

  def tech_request
    @quote = Quote.find params[:id]
    @department = Department.where(department_name: 'Quotes').first
    @issue = Issue.new
    @issue.department = @department
    @issue.client = @quote.client
    @issue.subject = "Check quote ##{@quote.id} for #{@quote.client.company}"
    @issue.quote = @quote
    @comment = @issue.comments.build
    @comment.content = "\"View quote\":/quotes/#{@quote.id}"
    @comment._np = 20
    @comment._ns = 40
    if @issue.save && @comment.save
      @quote.send_for_approval!
      redirect_to @quote
    else
      logger.fatal @issue.errors.messages
      logger.fatal @comment.errors.messages
    end
  end

  def client_request
    @quote = Quote.find params[:id]
    @password = SecureRandom.hex(10)
    @quote.update_attribute :password, @password
    @quote.send_for_client_approval!
    SendQuote.perform_async(@quote.id, @password)
    redirect_to @quote
  end

  def client_approve
    @quote = Quote.find params[:id]
    @quote.client_approve!
    redirect_to @quote
  end

  def phone_approve
    @quote = Quote.find params[:id]
    @quote.client_approve!
    redirect_to @quote
  end

  def goods_received
    @quote = Quote.find params[:id]
    @quote.receive_goods!
    redirect_to @quote
  end

  def payment_received
    @quote = Quote.find params[:id]
    @quote.receive_payment!
    redirect_to @quote
  end

  def payment_sent
    @quote = Quote.find params[:id]
    @quote.send_payment!
    redirect_to @quote
  end

  def complete
    @quote = Quote.find params[:id]
    @quote.complete!
    redirect_to @quote
  end

  def client_login
    @quote ||= Quote.find params[:id]
    if params[:username] && params[:password]
      if @quote.email == params[:username] && @quote.password_digest == BCrypt::Engine.hash_secret(params[:password], @quote.password_salt)
        session[:client_approved] = @quote.id
        redirect_to client_view_quote_path(@quote)
      end
    else
      render layout: 'sessions'
    end
  end

  def client_view
    @quote ||= Quote.find params[:id]
  end

  private

  def quote_params
    params.require(:quote).permit(:id, :client_id, :email, :requirements, :password, :carriage_cost, :carriage_sale, :supplier_quotes_attributes => [ :id, :quote_id, :description, :qty, :unit_price, :sale_price, :_destroy, :supplier_assignment_attributes => [ :id, :supplier_id, :supplier_quote_id ]])
  end

  def require_password!
    @quote = Quote.find params[:id]
    redirect_to client_login_quote_path unless session[:client_approved] == @quote.id
  end
end
