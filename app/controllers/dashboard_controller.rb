class DashboardController < ApplicationController
  def index
    @budget_summaries = Budget.all.order(:id).map { |budget| BudgetSummary.new(budget) }
  end
end
