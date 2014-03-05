class ClientsController < ApplicationController
  before_filter :require_login!

  def index
    @clients = Client.ordered
  end

  def new
    @client = Client.new
    @client.branches.build
    @client.branches.first.contacts.build
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    @client = Client.new(client_params)
    if check_validation(@person)
      render :action => :new
    else
      @person.forename = @person.username
      @person.surname = @person.username
      @person.email =   @person.username + '@ticket.com'
      @person.username = @person.username
      @person.password = @person.password
      @person.password_confirmation = @person.password_confirmation
      @person.client = 1
      @person.save(validate: false)
      if @person.save
        @client.people_id = @person.id
        @client.save 
        redirect_to clients_path
      else
        render :action => :new  
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
    
    unless @client.people_id.nil?
      people_id = @client.people_id 
      @person = Person.find(people_id)
    end
  end

  def update
    @client = Client.find(params[:id])

    unless @client.people_id.nil?
      people_id = @client.people_id
      @person = Person.find(people_id)
    else
      @person = Person.new(person_params)
      @person.forename = @person.username
      @person.surname = @person.username
      @person.email =   @person.username + '@ticket.com'
      @person.username = @person.username
      @person.password = @person.password
      @person.password_confirmation = @person.password_confirmation
      @person.client = 1
      if @person.username || @person.password
        @person.save(validate: false)  
        @client.update_attributes(:people_id => @person.id)
      end
    end

    @person_postparams = Person.new(person_params)
    if check_edit_validation(@person_postparams)
      render :action => :edit
    else
      @person.update_attributes(person_params)

      if @client.update_attributes(client_params)
        redirect_to clients_path
      else
        render :action => :edit
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    # Need to process assigned tickets
    redirect_to clients_path
  end

  def list
    @client = Client.find(params[:id])
  end

  def healthchecks
    @clients = Client.where(active_client: true).order(company: :asc)
  end

  private

  def client_params
    params.require(:client).permit(:id, :company, :group, :contact_phone, :contact_phone_ext, :wiki_page, :check_date, :active_client, :branches_attributes => [ :id, :branch_name, :contact_phone, :contact_phone_ext, :contacts_attributes => [:id, :forename, :surname, :email, :contact_phone, :contact_phone_ext, :contact_mobile, :_destroy]])
  end

  def person_params
    params.require(:person).permit!
  end
  
  def check_validation(person)
    person_exist = Person.find_by_username(person.username)
    if person.username.blank?
      person.errors.add :base, "Username required"
    elsif person_exist
      person.errors.add :base, "Username already exist"  
    elsif person.password.blank?
      person.errors.add :base, "Password required"
    elsif person.password_confirmation.blank?
      person.errors.add :base, "Password confirmation required"
    elsif person.password_confirmation != person.password
      person.errors.add :base, "Password and confirmation password not match"
    end
  end
  
  def check_edit_validation(person)
    
    if person.password_confirmation != person.password
      person.errors.add :base, "Password and confirmation password not match"
    end
  end
end
