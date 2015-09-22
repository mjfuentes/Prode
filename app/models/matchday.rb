class Matchday < ActiveRecord::Base
	has_many :matches, dependent: :destroy
	def self.restart
		Matchday.destroy_all
	end

	def self.history_for(player_id)
		return Matchday.where(started:true).collect() do |matchday| 
		{ 
			"created_at" => matchday.created_at,
			"id" => matchday.id,
			"matches" => matchday.matches.count, 
			"guesses" => matchday.matches.select() do |match|
				Guess.find_by(match_id: match.id, user_id: player_id) 
			end.count,
			"points" => matchday.matches.inject(0) do |result, match|
			 	guess = Guess.find_by(match_id: match.id, user_id: player_id)
			 	if guess && guess.points
			 		result + guess.points
			 	else
			 		result
			 	end
			end
		}
		end
	end

	def self.show_guesses(matchday_id, player_id)
		@matchday = Matchday.find_by id: matchday_id
		if !@matchday then return nil end
		return @matchday.matches.collect() do
			|match|
			{ "match" => match, "guess" => Guess.find_by(match_id: match.id, user_id: player_id)}
		end
	end

	def self.get_active
		return Matchday.find_by started:true, finished:false
	end	

	def self.get_created
		return Matchday.find_by started:false, finished:false
	end

	def self.no_active
		return Matchday.where(finished:false).count == 0
	end

	def finish
		if Match.find_by(matchday: self, finished: false) then return false end
		self.matches.each do |match|
			guesses = Guess.where match_id: match.id
		    guesses.each do |guess|
				guess.compare_to match
		    end
		end
		self.finished = true
		self.save
	end

	def not_started
		!self.started
	end

	def not_finished
		!self.finished
	end

	def simulate
		p self.matches.each
		self.matches.each do |match|
			if !match.finished
				match.home_score = rand(5)
				match.away_score = rand(5)
				match.finished = true
				match.save!
			end
		end
		self.finish
	end

	def start
		return false if self.started 
		self.started = true
		self.save
		User.new_matchday
	end

	def get_next_match(player_id)
		return self.matches.detect {|match| !Guess.find_by(match_id: match.id, user_id: player_id)}
	end
end
