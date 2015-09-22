class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    if user_signed_in?
      current_user.add_omniauth(request.env["omniauth.auth"])
      set_flash_message(:notice, :facebook_added)
      redirect_to root_path
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        set_flash_message(:error, :not_registered)
        redirect_to new_user_session_path
      end
    end
  end
end