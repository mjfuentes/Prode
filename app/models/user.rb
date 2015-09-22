class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	devise :omniauthable, :omniauth_providers => [:facebook]
  	validates :name, :presence => true
  	validates :email, uniqueness: true
  	after_initialize :init

  	def add_omniauth(auth)
  		self.provider = auth.provider
  		self.uid = auth.uid
  		self.save!
  	end

  	def self.from_omniauth(auth)
		find_by(provider: auth.provider, uid: auth.uid)
  	end

  	def self.new_with_session(params, session)
	    super.tap do |user|
	      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
	        user.email = data["email"] if user.email.blank?
	      end
	    end
  	end

	def self.ranking
		@players = User.where(admin: false).collect do |player|
			{"name" => player.name, "points" => Guess.where(user_id:player.id).inject(0) do |result, guess|
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
		@players = User.where admin: false
	    @players.each do |player|
	      if player.email
	        PlayerMailer.new_matchday(player).deliver_later
	      end
	    end
	end

	def init
      self.admin ||= false         
    end
end
