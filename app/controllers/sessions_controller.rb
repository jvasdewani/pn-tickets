class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      session[:authed_user] = @session.person.id
      redirect_to root_path
    else
      flash[:error] = 'We didn\'t recognise the username/email address or password you entered. Please try again.'.html_safe
      render :new
    end
  end

  def destroy
    session[:authed_user] = nil
    redirect_to new_session_path, success: "Signed out!"
  end
end
