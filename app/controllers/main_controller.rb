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
end
