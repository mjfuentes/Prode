require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  test "save_matchday" do
    matchday = Matchday.find_by started:true
    assert Match.new(matchday_id:matchday.id,home_team: "River", away_team: "Boca").save
  end
end
