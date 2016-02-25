class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_valid_password

  private

  def ensure_valid_password
    if password_protection.invalid?
      redirect_to new_session_path
    end
  end

  def password_protection
    @password_protection ||= ControllerPasswordProtection.new(self)
  end
end
