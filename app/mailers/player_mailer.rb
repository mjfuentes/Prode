class PlayerMailer < ApplicationMailer
	def new_matchday(user) 
	@user = user
    mail( to: @user.email, subject: "New Matchday available!") 
  end 
end
