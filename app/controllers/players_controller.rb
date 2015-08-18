class PlayersController < ApplicationController
  def new
  	if (valid_username(params[:username])) then
		if (!exists_user(params[:username])) then
			@player = Player.new(name: params[:name],username: params[:username], password: params[:password])
			@player.save	
			session[:username] = @player.username
			session[:userid] = @player.id
			@error = "Usuario creado exitosamente"
		else
			@error = "El nombre de usuario ya existe."
		end
	else
		@error = "El nombre de usuario no es valido"
	end
  end

  	def valid_username(username) 
		/^[a-zA-Z0-9][a-zA-Z0-9_]*$/ =~ username 
	end

	def exists_user(username)
		Player.find_by username: username
	end
end
