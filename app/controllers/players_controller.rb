class PlayersController < ApplicationController

	def new
		@error = ''
		if (valid_username(params[:username])) 
			if (!exists_user(params[:username])) then
				@player = Player.new(name: params[:name],username: params[:username], password: params[:password])
				@player.save	
				@error = "Usuario creado exitosamente"
				render 'main/welcome'
			else
				@error = "El nombre de usuario ya existe."
				render 'main/register'
			end
		else
			@error = "El nombre de usuario no es valido"
			render 'main/register'
		end
	end

	def valid_username(username) 
		/^[a-zA-Z0-9][a-zA-Z0-9_]*$/ =~ username 
	end

	def exists_user(username)
		Player.find_by username: username
	end
end
