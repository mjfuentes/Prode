class PlayersController < ApplicationController

	def new
		@error = ''
		if (valid_username(params[:username])) 
			if (!exists_user(params[:username])) then
				@player = Player.new(name: params[:name],username: params[:username], password: params[:password])
				@player.save	
				flash[:notice] = 'Succesfuly created user'
				redirect_to :controller => 'main', :action => 'welcome'
			else
				flash[:notice] = 'El nombre de usuario ya existe.'
				redirect_to :controller => 'main', :action => 'register'
			end
		else
			render 'main/register'
			flash[:notice] = 'Invalid username'
			redirect_to :controller => 'main', :action => 'register'
		end
	end

	def valid_username(username) 
		/^[a-zA-Z0-9][a-zA-Z0-9_]*$/ =~ username 
	end

	def exists_user(username)
		Player.find_by username: username
	end
end
