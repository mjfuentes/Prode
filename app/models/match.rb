class Match < ActiveRecord::Base
	has_many :guesses, dependent: :destroy
	belongs_to :matchday
end
