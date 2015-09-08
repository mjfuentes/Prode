class PlayerMailer < ApplicationMailer
	def new_matchday(user) 
	@user = user
    mail( to: @user.email, subject: I18n.t 'email.new_matchday') 
  end 
end
