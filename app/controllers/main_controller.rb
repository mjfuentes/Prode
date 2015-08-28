class MainController < ApplicationController
	def index
	end

	def welcome
		if session[:userid]
			redirect_to '/home'
		else 
			notice = params['notice']
			render 'main/welcome'
		end
	end

	def register_form
		render 'main/register'
	end

	def home
		if session[:userid]
			@player = Player.find_by id: session[:userid]
			notice = params[:notice]
			render 'home'
		else
			redirect_to ''
		end
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
				flash[:notice] = 'Usuario o contraseña invalida.' 
				redirect_to :action => 'login'
			end
		else
			flash[:notice] = 'Debe ingresar usuario y contraseña ' 
			redirect_to :action => 'login'
		end
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
				flash[:notice] = 'Facebook added.' 
				redirect_to :action => 'home'
			else 
				flash[:notice] = 'There has been an error.'
				redirect_to :action => 'home' 
			end
		else
			user = Player.find_by facebookid: @auth.uid
			if user
				session[:username] = user.username
				session[:userid] = user.id
				redirect_to :action => 'home'
			else
				flash[:notice] = 'Not a registered user.' 
				redirect_to :action => 'login'
			end
		end
	end
end
