class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery 
  	def is_admin
  		if session[:userid]
			current_user.admin?
		end
	end

	def current_user
    	@current_user ||= Player.find_by id: session[:userid]
  	end

	helper_method :is_admin, :current_user
end
