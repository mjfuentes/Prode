class GameController < ApplicationController
	def play
		check_logged_in or return
		@matchday = Matchday.get_active
		if @matchday
			@match = @matchday.get_next_match(current_user.id)
			if @match 
				@player = current_user
				@guess = Guess.new
			else
				flash[:notice] = I18n.t 'game.all_matches_guessed'
				redirect_to :controller => 'main', :action => 'home'
			end
		else
			flash[:error] = I18n.t 'game.no_active_matchday'
			redirect_to :controller => 'main', :action => 'home'
		end
	end

	def save
		check_logged_in or return
		@guess = Guess.new(guess_params)
		if (session[:userid] == @guess.user_id)
			if @guess.save
				flash[:notice] = I18n.t 'game.result_saved'
				redirect_to action: 'play'
			else
				@matchday = Matchday.get_active
				@match = @matchday.get_next_match(current_user.id)
				@player = current_user
				render 'game/play'
			end
		else
			flash[:error] = I18n.t 'user.invalid'
			redirect_to :controller => 'main', :action => 'home'
		end
	end

	def history
		check_logged_in or return
		@matchdays = Matchday.history_for(current_user.id)
	end

	def show
		check_logged_in or return
		@items = Matchday.show_guesses(params[:id],current_user.id)
		if !@items
			flash[:error] = I18n.t 'game.matchday_not_found'
			redirect_to :controller => 'game', :action => 'history'
		end
	end

	def ranking
		@players = Player.ranking
	end

	def guess_params
      params.require(:guess).permit(:user_id, :match_id, :home_score, :away_score)
    end
end
