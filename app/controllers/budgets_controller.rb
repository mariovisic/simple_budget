class BudgetsController < ApplicationController
  def index
    @budgets = Budget.all.order(:id)
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

  def edit
    budget = Budget.find(params[:id])

    @budget_form = BudgetForm.new(budget.attributes)
  end

  def update
    budget = Budget.find(params[:id])
    @budget_form = BudgetForm.new(budget.attributes.merge(budget_params))

    if @budget_form.save
      redirect_to budgets_path, flash: { notice: "#{budget.name} updated" }
    else
      render :new
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    @budget.transactions.destroy_all
    @budget.destroy

    redirect_to budgets_path, flash: { notice: "#{@budget.name} deleted" }
  end

  private

  def budget_params
    params.require(:budget).permit(:name, :weekly_deposit)
  end
end
