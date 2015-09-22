require 'test_helper'

class MatchTest < ActiveSupport::TestCase

	def setup
    	@matchday = matchdays(:not_started)
    	@ended = matchdays(:ended)
    	@started = matchdays(:started)
  	end

	test "fail_save" do
		match = Match.new()
		assert_not match.save
	end

	test "started_matchday" do
		match = Match.new(matchday: @started,home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "2")
		assert_not match.save
	end

	test "ended_matchday" do
		match = Match.new(matchday: @ended,home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "2")
		assert_not match.save
	end

	test "invalid_home_score" do
		match = Match.new(matchday: @matchday,home_score: "sab",away_score: "3", home_team_id: "1", away_team_id: "2")
		assert_not match.save
	end

	test "invalid_away_score" do
		match = Match.new(matchday: @matchday, home_score: "2",away_score: "xs3", home_team_id: "1", away_team_id: "2")
		assert_not match.save
	end

	test "invalid_home_team" do
		match = Match.new(matchday: @matchday,home_score: "sab",away_score: "3", home_team_id: "b", away_team_id: "2")
		assert_not match.save
	end

	test "invalid_away_team" do
		match = Match.new(matchday: @matchday, home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "c")
		assert_not match.save
	end

	test "same_team" do
		match = Match.new(matchday: @matchday, home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "1")
		assert_not match.save
	end

	test "already_used_home_team" do
		match = Match.new(matchday: @matchday,home_score: "5",away_score: "1", home_team_id: "1", away_team_id: "2")
		assert match.save
		match_two = Match.new(matchday: @matchday, home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "3")
		assert_not match_two.save
	end

	test "already_used_away_team" do
		match = Match.new(matchday: @matchday,home_score: "5",away_score: "1", home_team_id: "1", away_team_id: "2")
		assert match.save
		match_two = Match.new(matchday: @matchday, home_score: "2",away_score: "3", home_team_id: "3", away_team_id: "1")
		assert_not match_two.save
	end

	test "ok_different_teams" do
		match = Match.new(matchday: @matchday,home_score: "5",away_score: "1", home_team_id: "1", away_team_id: "2")
		assert match.save
		match_two = Match.new(matchday: @matchday, home_score: "2",away_score: "3", home_team_id: "3", away_team_id: "4")
		assert match_two.save
	end

	test "absent_matchday" do
		match = Match.new(home_score: "2", away_score: "3", home_team_id: "1", away_team_id: "2")
		assert_not match.save
	end

	test "save_ok" do
		match = Match.new(matchday: @matchday,home_score: "5",away_score: "1", home_team_id: "1", away_team_id: "2")
		assert match.save
	end

	test "home_wins" do
		match = Match.new(matchday: @matchday,home_score: "5",away_score: "1", home_team_id: "1", away_team_id: "2")
		assert match.save
		assert match.home_wins?
		assert_not match.away_wins?
		assert_not match.tie?
	end

	test "away_wins" do
		match = Match.new(matchday: @matchday,home_score: "2",away_score: "3", home_team_id: "1", away_team_id: "2")
		assert match.save
		assert_not match.home_wins?
		assert match.away_wins?
		assert_not match.tie?
	end

	test "tie" do
		match = Match.new(matchday: @matchday,home_score: "4",away_score: "4", home_team_id: "1", away_team_id: "2")
		assert match.save
		assert_not match.home_wins?
		assert_not match.away_wins?
		assert match.tie?
	end
end
