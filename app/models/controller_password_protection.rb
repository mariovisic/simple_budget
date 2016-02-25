require 'bcrypt'

class ControllerPasswordProtection
  def initialize(controller)
    @controller = controller
  end

  def invalid?
    password.present? && !@controller.session[:logged_in]
  end

  def grant_access
    @controller.session[:logged_in] = true
  end

  def password
    ENV['PASSWORD_HASH'].presence
  end
end
