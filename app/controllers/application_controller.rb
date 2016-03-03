class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_logged_in
  before_action :update_budgets
  before_action :assign_helpers

  private

  def ensure_logged_out
    if user_session.logged_in?
      redirect_to root_path
    end
  end

  def ensure_logged_in
    if user_session.logged_out?
      redirect_to new_session_path
    end
  end

  def user_session
    @user_session ||= UserSession.new(self)
  end

  def update_budgets
    BudgetUpdater.update_all
  end

  def assign_helpers
    ApplicationPresenter.helpers = self.class.helpers
  end
end
