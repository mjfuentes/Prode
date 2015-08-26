ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "matiasj.fuentes",
  :password             => "nogood.5.f.2.w.h.neednew",
  :authentication       => "plain",
  :enable_starttls_auto => true
}