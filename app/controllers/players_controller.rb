class PlayersController < ApplicationController
	def new
		@error = ''
		if ((valid_username(params[:username])) && (valid_email(params[:email])))
			if ((!exists_user(params[:username])) && (!exists_email(params[:email]))) then
				@player = Player.new(name: params[:name],username: params[:username], password: params[:password], email: params[:email])
				@player.save	
				flash[:notice] = 'Succesfuly created user'
				redirect_to :controller => 'main', :action => 'welcome'
			else
				flash[:notice] = 'El usuario ya existe.'
				redirect_to :controller => 'main', :action => 'register'
			end
		else
			flash[:notice] = 'Invalid username'
			redirect_to :controller => 'main', :action => 'register'
		end
	end

	def valid_username(username) 
		/^[a-zA-Z0-9][a-zA-Z0-9_]*$/ =~ username 
	end

	def valid_email(email)
		/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i =~ email
	end

	def exists_user(username)
		Player.find_by username: username
	end

	def exists_email(email)
		Player.find_by email: email
	end
end
