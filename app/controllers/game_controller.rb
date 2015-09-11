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

	def simulate
	    check_logged_in or return
	    check_admin or return
	    if Matchday.no_active
	      @matchday = Matchday.new(finished: false, started: false)
	      @matchday.save
	      @available_teams = Team.get_available @matchday.id
	      while @available_teams.size > 1 do
	        @team_one = @available_teams.sample
	        @available_teams.delete(@team_one)
	        @team_two = @available_teams.sample
	        @available_teams.delete(@team_two)
	        Match.new(home_team_id: @team_one.id, away_team_id: @team_two.id, matchday_id: @matchday.id, finished: 0).save
	      end
	      @matchday.start
	      flash[:notice] = I18n.t 'matchday.simulated'
	      redirect_to home_path
	    else 
	      flash[:error] = I18n.t 'matchday.active_matchday_exists'
	      redirect_to home_path
	    end
  	end

	def ranking
		@players = Player.ranking
	end

	def guess_params
      params.require(:guess).permit(:user_id, :match_id, :home_score, :away_score)
    end
end
