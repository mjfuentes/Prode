json.array!(@guesses) do |guess|
  json.extract! guess, :id, :user_id, :team_one, :team_two, :guess_result_id, :result_id
  json.url guess_url(guess, format: :json)
end
