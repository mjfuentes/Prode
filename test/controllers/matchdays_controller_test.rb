require 'test_helper'

class MatchdaysControllerTest < ActionController::TestCase
	
	def setup
		@matchday = Matchday.find_by started:true
	  	@match = Match.new(matchday_id:@matchday.id,home_team: "River", away_team: "Boca")
	  	@match.home_score = 3
	  	@match.away_score = 2
	  	@match.save
	  	@player_one = Player.find_by username: "matias"
	  	@player_two = Player.find_by username: "pedro"
	  	@player_three = Player.find_by username: "juan"
	  	Guess.new(home_score: 3, away_score: 2,match_id: @match.id,user_id: @player_one.id).save
	  	Guess.new(home_score: 5, away_score: 1,match_id: @match.id,user_id: @player_two.id).save
	  	Guess.new(home_score: 2, away_score: 2,match_id: @match.id,user_id: @player_three.id).save
	  	@controller = MatchdaysController.new
	end
	
	test "points" do
	  	@controller.calculate_points(@matchday)

	  	guess_one = Guess.find_by match_id: @match.id,user_id: @player_one.id
	  	guess_two = Guess.find_by match_id: @match.id,user_id: @player_two.id
	  	guess_three = Guess.find_by match_id: @match.id,user_id: @player_three.id
	  	assert_equal 5, guess_one.points
	  	assert_equal 2, guess_two.points
	  	assert_equal 0, guess_three.points
  	end


end
