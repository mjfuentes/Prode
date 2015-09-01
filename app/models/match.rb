class Match < ActiveRecord::Base
	has_many :guesses, dependent: :destroy
	belongs_to :matchday
	validates :home_team, :away_team, :presence => true
end
