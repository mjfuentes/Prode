class PlayersController < ApplicationController
	def new
		@error = ''
		if ((valid_username(params[:username])) && (valid_email(params[:email])))
			if ((!exists_user(params[:username])) && (!exists_email(params[:email]))) then
				@player = Player.new(name: params[:fullname],username: params[:username], password: params[:password], email: params[:email], admin:false)
				if @player.save	
					flash[:notice] = I18n.t 'user.created'
					redirect_to :controller => 'main', :action => 'welcome'
				else
					flash[:error] = I18n.t 'user.create_error'
					redirect_to :controller => 'main', :action => 'register'
				end
			else
				flash[:error] = I18n.t 'user.already_exists'
				redirect_to :controller => 'main', :action => 'register'
			end
		else
			flash[:error] = I18n.t 'user.invalid_username_email'
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
