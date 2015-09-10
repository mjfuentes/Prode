class Player < ActiveRecord::Base
	validates :name, :username, :password, :email, :presence => true
	validates_inclusion_of :admin, :in => [true, false]
	validates :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
	validates :username, uniqueness: true, format: { with: /\A[a-z0-9\-_]+\z/}
	validates :password, format: { with: /\A[a-z0-9\-_]+\z/ }


	def self.ranking
		@players = Player.where(admin: false).collect do |player|
			{"username" => player.username, "points" => Guess.where(user_id:player.id).inject(0) do |result, guess|
				if guess.points
					result + guess.points
				else
					result
				end
			end
			}
		end
		return @players.sort_by do
			|player|
			player["points"]
		end.reverse
	end

	def self.new_matchday
		@players = Player.where admin: false
        @players.each do |player|
          if player.email
            # PlayerMailer.new_matchday(player).deliver_later
          end
        end
    end
end
