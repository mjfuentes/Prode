OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '115727572111076', 'dee2083ec923e6d25ffb5bdf38f4da35', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end