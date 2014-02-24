class PreferencesController < ApplicationController
  before_filter :require_login!

  def edit
    @person = current_person
  end

  def update
    @person = current_person
    if @person.update_attributes(person_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def person_params
    params.require(:person).permit(:id, :forename, :surname, :email, :department_id, :username, :password, :password_confirmation, :tickets, :reports, :contacts, :manager, :admin)
  end
end
