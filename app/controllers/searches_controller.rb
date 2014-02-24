class SearchesController < ApplicationController
  before_filter :require_login!

  def new
    @search = Search.new
  end

  def create
    session[:search] = params[:search]
    #render :text => params[:search].inspect and return false

    @search = Search.new(session[:search].merge({page: params[:page]}))
    if !@search.save
      render :new
    else
      @bulk_edit = MultiTicketEdit.new if current_person.admin?
      render :index
    end
  end

  def index
   # render :text => params[:search].inspect and return false
    @search = Search.new(session[:search].merge({page: params[:page]}))
    if !@search.save
      render :new
    else
      @bulk_edit = MultiTicketEdit.new if current_person.admin?
    end
  end
end
