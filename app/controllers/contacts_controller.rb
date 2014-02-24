class ContactsController < ApplicationController
  def create
    @client = Client.find(params[:client_id])
    @branch = @client.branches.find(params[:branch_id])
    @contact = @branch.contacts.new
    @contact.forename = params[:name].split(' ').compact.first.titleize
    @contact.surname = params[:name].split(' ').compact.last.titleize
  end
end
