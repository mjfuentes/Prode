require 'test_helper'

class MatchdaysControllerTest < ActionController::TestCase
	
	def setup
		@matchday = Matchday.find_by started:true
	  	@match = Match.new(matchday:@matchday,home_team_id: 1, away_team_id: 2, finished: false)
	  	@match.home_score = 3
	  	@match.away_score = 2
	  	@match.save
	  	Guess.new(home_score: 3, away_score: 2,match_id: @match.id,user_id: players(:matias).id).save
	  	Guess.new(home_score: 5, away_score: 1,match_id: @match.id,user_id: players(:pedro).id).save
	  	Guess.new(home_score: 2, away_score: 2,match_id: @match.id,user_id: players(:juan).id).save
	  	@controller = MatchdaysController.new
	end
	
	test "calculate_points_fail" do
	  	@controller.calculate_points(@matchday)
	  	guess_one = Guess.find_by match_id: @match.id,user_id: @player_one.id
	  	guess_two = Guess.find_by match_id: @match.id,user_id: @player_two.id
	  	guess_three = Guess.find_by match_id: @match.id,user_id: @player_three.id
	  	assert_not_equal 3, guess_one.points
	  	assert_not_equal 1, guess_two.points
	  	assert_not_equal 4, guess_three.points
  	end

	test "calculate_points_ok" do
	  	@controller.calculate_points(@matchday)
	  	guess_one = Guess.find_by match_id: @match.id,user_id: @player_one.id
	  	guess_two = Guess.find_by match_id: @match.id,user_id: @player_two.id
	  	guess_three = Guess.find_by match_id: @match.id,user_id: @player_three.id
	  	assert_equal 5, guess_one.points
	  	assert_equal 2, guess_two.points
	  	assert_equal 0, guess_three.points
  	end

  	test "end_with_active_matches" do
  		get(:end, {'id' => @matchday.id}, {'userid' => @admin.id})
  		active_matches = Match.where(matchday: @matchday, finished: false)
  		matchday = Matchday.find_by id: @matchday.id

  		assert_equal 1, active_matches.length
    	assert !matchday.finished 
  	end

  	test "end_without_active_matches" do
  		@match.finished = true
  		@match.save
  		get(:end, {'id' => @matchday.id}, {'userid' => @admin.id})
  		active_matches = Match.where(matchday: @matchday, finished: false)
  		matchday = Matchday.find_by id: @matchday.id
    	
  		assert_equal 0, active_matches.length
    	assert matchday.finished 
  	end


end
