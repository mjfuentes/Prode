class Guess < ActiveRecord::Base
	belongs_to :user
	validates :home_score, :away_score, :match_id, :user_id, :presence => true, numericality: { only_integer: true }
end
