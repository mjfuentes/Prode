class PlayersController < ApplicationController
	def create
		@player = Player.new(match_params.merge(:admin => false))
		if @player.valid?	
			@player.save
			flash[:notice] = I18n.t 'user.created'
			redirect_to :controller => 'main', :action => 'welcome'
		else
			render 'main/register'
		end
	end

	private 
	def match_params
      params.require(:player).permit(:name, :username, :password, :email)
    end
end
