json.array!(@matches) do |match|
  json.extract! match, :id, :home_team, :away_team, :home_score, :away_score, :finished
  json.url match_url(match, format: :json)
end
