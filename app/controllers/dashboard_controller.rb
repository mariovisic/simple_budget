class DashboardController < ApplicationController
  def index
    @budget_summaries = Budget.all.map { |budget| BudgetSummary.new(budget) }
  end
end
