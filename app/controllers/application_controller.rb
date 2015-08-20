class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery 
  	def is_admin
  		if session[:userid]
			@player = Player.find_by id: session[:userid]
			@player.admin?
		end
	end
	helper_method :is_admin
end
