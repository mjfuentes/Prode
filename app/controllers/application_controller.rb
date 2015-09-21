class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = I18n.t 'access.denied'
    redirect_to root_url
  end

	def current_user
    	@current_user ||= Player.find_by id: session[:userid]
	end

	helper_method :current_user
end
