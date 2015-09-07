ActionMailer::Base.smtp_settings = {
  :address              => "smtp.live.com",#GMAIL: smtp.gmail.com
  :port                 => 587,
  :domain               => "hotmail.com",
  :user_name            => "USUARIO@DOMINO.com",
  :password             => "CONTRASEÑA",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options = { :host => 'localhost:3000' }
ActionMailer::Base.default :from => 'USUARIO@DOMINO.com'