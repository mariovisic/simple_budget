class BudgetsController < ApplicationController
  def index
  end

  def new
    @budget_form = BudgetForm.new
  end

  def create
    @budget_form = BudgetForm.new(budget_params)

    if @budget_form.save
      redirect_to budgets_path, flash: { notice: 'Budget created' }
    else
      render :new
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:name, :weekly_deposit)
  end
end
