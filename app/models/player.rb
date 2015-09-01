class Player < ActiveRecord::Base
	validates :name, :username, :password, :email, :presence => true
	validates_inclusion_of :admin, :in => [true, false]
end
