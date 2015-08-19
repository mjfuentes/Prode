class MainController < ApplicationController
  def index
  end

  def welcome
  end

  def register_form
  end

  def home
  	@player = Player.find_by id: session[:userid]
  	render 'home'
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
				@error = "Usuario o contraseña invalida"
				render 'main/login'
			end
		else
			@error = "Debe ingresar usuario y contraseña"
			render 'main/login'
		end
	end
end
