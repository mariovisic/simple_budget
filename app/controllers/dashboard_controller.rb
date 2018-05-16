class DashboardController < ApplicationController
  def index
    @budget_summaries = Budget.all.order(:id).map { |budget| BudgetSummary.new(budget) }
    @quick_transactions = Transaction.group(:name, :company).where('amount > 0').having('count(*) >= ?', quick_transaction_min_count).order('count(*) DESC').count.map { |transaction| QuickTransactionPresenter.new(transaction) }
  end

  private

  def quick_transaction_min_count
    Rails.application.config.min_transactions_for_quick_transaction
  end
end
