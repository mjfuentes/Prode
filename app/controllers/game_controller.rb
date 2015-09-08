class GameController < ApplicationController

	def play
		check_logged_in or return
		@player = Player.find_by id: session[:userid]
		@matchday = Matchday.find_by started:true, finished:false
		if @matchday
			@matches = Match.where matchday: @matchday
			@match = @matches.detect {|match| !Guess.find_by(match_id: match.id, user_id: @player.id)}
			if @match 
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
				flash[:error] = I18n.t 'game.result_save_error'
				redirect_to :controller => 'main', :action => 'home'
			end
		else
			flash[:error] = I18n.t 'user.invalid'
			redirect_to :controller => 'main', :action => 'home'
		end
	end

	def history
		check_logged_in or return
		@player = Player.find_by id: session[:userid]
		@matchdays = Matchday.where(started:true, finished:true).collect() {
			|matchday| 
			{ "created_at" => matchday.created_at,"id" => matchday.id, "matches" => matchday.matches.count, "guesses" => matchday.matches.select() {
				|match|
				 Guess.find_by(match_id: match.id, user_id: @player.id) }.count, "points" => matchday.matches.inject(0) {
				 	|result, match|
				 	guess = Guess.find_by(match_id: match.id, user_id: @player.id)
				 	if guess && guess.points
				 		result + guess.points
				 	else
				 		result
				 	end
				 }
			}
		}
	end

	def show
		check_logged_in or return
		@matchday = Matchday.find_by id: params[:id]
		@player = Player.find_by id: session[:userid]
		@items = @matchday.matches.collect() {
			|match|
			{ "match" => match, "guess" => Guess.find_by(match_id: match.id, user_id: @player.id)}
		}
	end

	def ranking
		@players = Player.where(admin: false).collect { 
			|player|
			{"username" => player.username, "points" => Guess.where(user_id:player.id).inject(0) {|result, guess|
				if guess.points
					result + guess.points
				else
					result
				end
				}
			}
		}
		@players = @players.sort_by {
			|player|
			player["points"]
		}.reverse
	end

	def guess_params
      params.require(:guess).permit(:user_id, :match_id, :home_score, :away_score)
    end
end
