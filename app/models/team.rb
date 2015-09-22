class Team < ActiveRecord::Base
	validates :name, :presence => true, uniqueness: true

	def self.get_available(matchday_id)
		return Team.all.select do |team|
			available_team(matchday_id, team.id)
		end
	end

	def self.is_available(team_id)
		@matchday = Matchday.get_created
		@matchday && available_team(@matchday.id, team_id)
	end
	
	private 
	def self.available_team(matchday_id, team_id)
		Match.where(["matchday_id = :matchday and (home_team_id = :team or away_team_id = :team)", {matchday: matchday_id, team: team_id}]).size == 0
	end
end
