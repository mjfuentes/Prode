class GameController < ApplicationController

	def play
		if session[:userid]
			@player = Player.find_by id: session[:userid]
			@matchday = Matchday.find_by started:true, finished:false
			if @matchday
				@matches = Match.where matchday: @matchday
				@match = @matches.detect {|match| !Guess.find_by(match_id: match.id, user_id: @player.id)}
				if @match 
					@guess = Guess.new
				else
					flash[:notice] = 'Already guessed every match.'
					redirect_to :controller => 'main', :action => 'home'
				end
			else
				flash[:notice] = 'No matchday currently active.'
				redirect_to :controller => 'main', :action => 'home'
			end
		else
			redirect_to :controller => 'main', :action => 'welcome'
		end
	end

	def save
		if session[:userid] 
			@guess = Guess.new(guess_params)
			if (session[:userid] == @guess.user_id)
				if @guess.save
					flash[:notice] = 'Result saved succesfully.'
					redirect_to action: 'play'
				else
					flash[:notice] = 'Couldnt save result.'
					redirect_to :controller => 'main', :action => 'home'
				end
			else
				flash[:notice] = 'Invalid user'
				redirect_to :controller => 'main', :action => 'home'
			end
		else
			redirect_to :controller => 'main', :action => 'welcome'
		end
	end

	def history
		if session[:userid] 
			@player = Player.find_by id: session[:userid]
			@matchdays = Matchday.where(started:true, finished:true).collect() {
				|matchday| 
				{ "id" => matchday.id, "matches" => matchday.matches.count, "guesses" => matchday.matches.select() {
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
		else
			redirect_to :controller => 'main', :action => 'welcome'
		end
	end

	def show
		if session[:userid] 
			@matchday = Matchday.find_by id: params[:id]
			@player = Player.find_by id: session[:userid]
			@items = @matchday.matches.collect() {
				|match|
				{ "match" => match, "guess" => Guess.find_by(match_id: match.id, user_id: @player.id)}
			}
		else
			redirect_to :controller => 'main', :action => 'welcome'
		end
	end

	def ranking
		@players = Player.all.collect { 
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
