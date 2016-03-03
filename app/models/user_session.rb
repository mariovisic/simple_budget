require 'bcrypt'

class UserSession
  def initialize(controller)
    @controller = controller
  end

  def logged_out?
    password.present? && !@controller.session[:logged_in]
  end

  def logged_in?
    !logged_out?
  end

  def grant_access
    @controller.session[:logged_in] = true
  end

  def password
    ENV['PASSWORD_HASH'].presence
  end
end
