module Authentication

  class Unauthorized < StandardError; end

  def self.included(base)
    base.send(:include, Authentication::HelperMethods)
    base.send(:include, Authentication::ControllerMethods)
  end

  module HelperMethods

    def current_person
      begin
        raise Unauthorized unless session[:authed_user].present?
        @current_person ||= Person.find(session[:authed_user])
      rescue
        nil
      end
    end

    def authenticated?
      current_person.present?
    end

  end

  module ControllerMethods

    def require_login!
      raise Unauthorized unless session[:authed_user].present?
      authenticate Person.find(session[:authed_user])
    rescue
      redirect_to new_session_path and return false
    end

    def authenticate(person)
      raise Unauthorized unless person
      session[:authed_user] = person.id
    end

    def unauthenticate
      @current_person = session[:authed_user] = nil
    end

  end

end
