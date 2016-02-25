class LoginForm
  include ActiveModel::Model

  attr_accessor :password

  validate :ensure_password_matches

  def ensure_password_matches
    if stored_password.present? && stored_password != password
      errors.add(:password, "invalid")
      password = nil
    end
  end

  def stored_password
    ENV['PASSWORD_HASH'].presence && BCrypt::Password.new(ENV['PASSWORD_HASH'])
  end
end
