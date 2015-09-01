class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery 
  	def is_admin
  		if session[:userid]
		    return current_user.admin?
		  else
        return false
      end
	end

	def current_user
    	@current_user ||= Player.find_by id: session[:userid]
	end

  def check_logged_in
    if !session[:userid]
      redirect_to '/' and return
    end
    return true
  end

  def check_admin
    if !is_admin
      redirect_to '/' and return
    end
    return true
  end

	helper_method :is_admin, :current_user
end
