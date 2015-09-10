class MainController < ApplicationController

	def welcome
		if session[:userid]
			redirect_to '/home'
		else 
			notice = params['notice']
			render 'main/welcome'
		end
	end

	def register
		@player = Player.new
		render 'main/register'
	end

	def home
		check_logged_in or return
		@player = current_user
	end

	def login_form
		render 'main/login'
	end

	def login
		if (params[:username] && params[:password]) then
			player = Player.find_by username: params[:username], password: params[:password]
			if (player) then
				session[:username] = player.username
				session[:userid] = player.id
				redirect_to '/home'
			else
				flash[:error] = I18n.t 'login.invalid_user_password'
				redirect_to :action => 'login'
			end
		else
			flash[:error] =  I18n.t 'login.user_password_required'
			redirect_to :action => 'login'
		end
	end

	def restart
		check_logged_in or return
		check_admin or return
		Matchday.restart
		flash[:notice] = I18n.t 'game.restarted'
		redirect_to :action => 'home'
	end

	def logout
		if session[:userid] then
			reset_session
			redirect_to ''
		end
	end

	def facebook()
		@auth = env["omniauth.auth"]
		if session[:userid]
			current_user.facebookid = @auth.uid
			if current_user.save
				flash[:notice] = I18n.t 'user.facebook_account_added'
				redirect_to :action => 'home'
			else 
				flash[:error] = I18n.t 'user.save_fail'
				redirect_to :action => 'home' 
			end
		else
			user = Player.find_by facebookid: @auth.uid
			if user
				session[:username] = user.username
				session[:userid] = user.id
				redirect_to :action => 'home'
			else
				flash[:error] = I18n.t 'user.unknown_facebook_account'
				redirect_to :action => 'login'
			end
		end
	end
end
