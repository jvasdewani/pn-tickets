class PeopleController < ApplicationController
  before_filter :require_login!

  def index
    @people = Person.ordered
  end

  def new
    @person = Person.new
    @person.assignments.build
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to people_path
    else
      render :action => :new
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
      redirect_to people_path
    else
      render :action => :edit
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    redirect_to people_path
  end

  private

  def person_params
    params.require(:person).permit(:id, :forename, :surname, :email, :username, :password, :password_confirmation, :tickets, :reports, :contracts, :manager, :admin, :is_active, :quotes, :show_on_scoreboard, :assignments_attributes => [:id, :person_id, :department_id, :_destroy])
  end
end
