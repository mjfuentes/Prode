require 'test_helper'

class GuessTest < ActiveSupport::TestCase

	test "fail_save" do
		guess = Guess.new()
		assert_not guess.save
	end

	test "invalid_match_id" do
		guess = Guess.new(user_id: "1", match_id: "b",home_score: "2",away_score: "3")
		assert_not guess.save
	end

	test "invalid_home_score" do
		guess = Guess.new(user_id: "1", match_id: "1",home_score: "sab",away_score: "3")
		assert_not guess.save
	end

	test "invalid_away_score" do
		guess = Guess.new(user_id: "1", match_id: "1",home_score: "2",away_score: "xs3")
		assert_not guess.save
	end

	test "invalid_user_id" do
		guess = Guess.new(user_id: "sad23", match_id: "b",home_score: "2",away_score: "3")
		assert_not guess.save
	end

	test "absent_match_id" do
		guess = Guess.new(user_id: "1",home_score: "2",away_score: "3")
		assert_not guess.save
	end

	test "absent_home_score" do
		guess = Guess.new(user_id: "1", match_id: "1",away_score: "3")
		assert_not guess.save
	end

	test "absent_away_score" do
		guess = Guess.new(user_id: "1", match_id: "1",home_score: "2")
		assert_not guess.save
	end

	test "absent_user_id" do
		guess = Guess.new(user_id: "sad23",home_score: "2",away_score: "3")
		assert_not guess.save
	end

	test "home_wins" do
		guess = Guess.new(user_id: "2", match_id: "1",home_score: "5",away_score: "1")
		assert guess.home_wins?
		assert_not guess.away_wins?
		assert_not guess.tie?
	end

	test "away_wins" do
		guess = Guess.new(user_id: "2", match_id: "1",home_score: "2",away_score: "3")
		assert_not guess.home_wins?
		assert guess.away_wins?
		assert_not guess.tie?
	end

	test "tie" do
		guess = Guess.new(user_id: "2", match_id: "1",home_score: "4",away_score: "4")
		assert_not guess.home_wins?
		assert_not guess.away_wins?
		assert guess.tie?
	end

	test "guess_five_points" do
		guess = Guess.new(user_id: "1", match_id: "1",home_score: "3",away_score: "2")
		guess.compare_to(matches(:clasico))
		assert_equal guess.points, 5
	end

	test "guess_two_points" do
		guess = Guess.new(user_id: "2", match_id: "1",home_score: "5",away_score: "1")
		guess.compare_to(matches(:clasico))
		assert_equal guess.points, 2
	end

	test "guess_zero_points" do
		guess = Guess.new(user_id: "3", match_id: "1",home_score: "1",away_score: "1")
		guess.compare_to(matches(:clasico))
		assert_equal guess.points, 0
	end

end
