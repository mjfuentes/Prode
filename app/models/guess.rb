class Guess < ActiveRecord::Base
	belongs_to :user
	validates :home_score, :away_score, :match_id, :user_id, :presence => true, numericality: { only_integer: true }

	def compare_to(match)
		if (match.home_score == self.home_score && match.away_score == self.away_score)
			self.points = 5
		else 
			if (self.home_wins? && match.home_wins?) ||
				(self.away_wins? && match.away_wins?) ||
				(self.tie? && match.tie?)
				self.points = 2
			else 
				self.points = 0
			end
		end
		self.save
	end

	def home_wins?
		home_score > away_score
	end

	def away_wins?
		home_score < away_score
	end

	def tie?
		home_score == away_score
	end

end
