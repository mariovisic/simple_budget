class SessionsController < ApplicationController
  skip_before_action :ensure_logged_in
  before_action :ensure_logged_out

  def new
    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(login_form_params)

    if @login_form.valid?
      user_session.grant_access
      redirect_to root_path, flash: { notice: 'Logged in' }
    else
      render :new
    end
  end

  private

  def login_form_params
    params.require(:login_form).permit(:password)
  end
end
