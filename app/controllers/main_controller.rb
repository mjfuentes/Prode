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
				rendirect_to :action => 'login'
			end
		else
			flash[:notice] = 'Debe ingresar usuario y contraseña ' 
			rendirect_to :action => 'login'
		end
	end

	def logout
		if session[:userid] then
			reset_session
			redirect_to ''
		end
	end
end
