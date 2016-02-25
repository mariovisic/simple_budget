class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_valid_password
  before_action :update_budgets
  before_action :assign_helpers

  private

  def ensure_valid_password
    if password_protection.invalid?
      redirect_to new_session_path
    end
  end

  def password_protection
    @password_protection ||= ControllerPasswordProtection.new(self)
  end

  def update_budgets
    BudgetUpdater.update_all
  end

  def assign_helpers
    ApplicationPresenter.helpers = self.class.helpers
  end
end
