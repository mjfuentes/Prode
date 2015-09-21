class MainController < ApplicationController

	def welcome
		if user_signed_in?
			redirect_to '/home'
		end
	end

	def home
		if user_signed_in?
			@player = current_user
			render 'main/home'
		else
			render 'main/welcome'
		end
	end

	def restart
		authorize! :write, Matchday
		Matchday.restart
		flash[:notice] = I18n.t 'game.restarted'
		redirect_to :action => 'home'
	end

	def facebook()
		@auth = env["omniauth.auth"]
		if user_signed_in?
			current_user.facebookid = @auth.uid
			if current_user.save
				flash[:notice] = I18n.t 'user.facebook_account_added'
				redirect_to :action => 'home'
			else 
				flash[:error] = I18n.t 'user.save_fail'
				redirect_to :action => 'home' 
			end
		else
			user = User.find_by facebookid: @auth.uid
			if user
				session[:username] = user.username
				session[:userid] = user.id
				redirect_to :action => 'home'
			else
				flash[:error] = I18n.t 'user.unknown_facebook_account'
				redirect_to new_user_session_path
			end
		end
	end
end
