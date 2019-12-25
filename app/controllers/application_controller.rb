class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  add_flash_types :success, :danger

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

      def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :secondname, :lastname, :email, :password])
          devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :secondname, :lastname, :email, :password, :current_password])
      end

end
