# TODO: Needs refactoring after updating the graphs
include ActionView::Helpers::NumberHelper

class BudgetPresenter < ApplicationPresenter
  LARGE_TRANSACTION_THRESHOLD = 200

  def to_json
    balances.inspect.html_safe
  end

  private

  def starting_balance
    @starting_balance ||= begin
      first_transaction_id = find_transactions.first.id
      -Transaction.where('id < ?', first_transaction_id).sum(:amount)
    end
  end

  def find_transactions
    @transactions ||= Transaction.where('purchased_at < ? AND name != ?', 1.week.ago.end_of_week, 'Transfer').order(:purchased_at)
  end

  def transaction_weeks
    @transaction_weeks ||= (find_transactions.map do |transaction|
      datetime_to_week(transaction.purchased_at)
    end).uniq
  end

  private

  def datetime_to_week(datetime)
    datetime.end_of_week.strftime("%d %b %Y")
  end

  def balances
    week_data = Array.new(transaction_weeks.length) { { large_transactions: [], sum: 0 } }

    find_transactions.each do |transaction|
      week_index = transaction_weeks.index(datetime_to_week(transaction.purchased_at))
      week_data[week_index][:sum] += -transaction.amount

      if transaction.amount > LARGE_TRANSACTION_THRESHOLD
        week_data[week_index][:large_transactions].push(transaction)
      end
    end

    sum = starting_balance
    week_data.each_with_index.map do |data, index|
      amount = (sum += data[:sum])
      [transaction_weeks[index], amount.to_f, "<p class='transaction-tooltip'><strong>Balance:</strong> <span class='tooltip-amount'>#{number_to_currency(amount, precision: 0)}</span></p> #{large_transaction_text(data[:large_transactions])}".html_safe]
    end
   end

  def large_transaction_text(transactions)
    if transactions.present?
      "<ul class='large-transaction-tooltip'><strong>Large Transactions:</strong><br>" + (transactions.map do |transaction|
        "<li class='large-transaction-tooltip-inner'>#{transaction.name}: <span class='tooltip-amount'>#{number_to_currency(transaction.amount, precision: 0)}</span></li>"
      end).join + "</ul>"
    end
  end
end
