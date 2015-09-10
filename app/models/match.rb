class Match < ActiveRecord::Base
	has_many :guesses, dependent: :destroy
	belongs_to :home_team, :class_name => 'Team'
	belongs_to :away_team, :class_name => 'Team'
	belongs_to :matchday
	validates :home_team_id, :away_team_id, :presence => true, numericality: { only_integer: true }
	validates :home_score, :away_score, numericality: {:allow_blank => true, only_integer: true}
	validate :not_same_team

	private
	def not_same_team
	    errors.add(:away_team_id) unless away_team_id != home_team_id
	end

	def valid_home_team
		errors.add(:home_team_id) unless Team.is_available(home_team_id)
	end

	def valid_away_team
		errors.add(:away_team_id) unless Team.is_available(away_team_id)
	end
end