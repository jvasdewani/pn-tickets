class MultiTicketEditsController < ApplicationController
  before_filter :require_login!

  def create
    @bulk_update = MultiTicketEdit.new(params[:multi_ticket_edit])
    @bulk_update.save
    redirect_to :back
  end
end
