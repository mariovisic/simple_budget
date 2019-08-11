class BudgetPresenter < ApplicationPresenter
  def to_json
    ({
      point: {
        r: 4
      },

      data: {
        columns: balances,
        type: 'line'
      },
      bindto: "#weekly-budget-graph",
      axis: {
        x: {
          type: 'category',
          categories: transaction_weeks
        },
      }
    }).to_json.html_safe
  end

  private

  def starting_balance
    @starting_balance ||= begin
      first_transaction_id = find_transactions.first.id
      -Transaction.where('id < ?', first_transaction_id).sum(:amount)
    end
  end

  def find_transactions
    @transactions ||= Transaction.where('purchased_at > ? AND purchased_at < ? AND name != ?', 6.months.ago, 1.week.ago.end_of_week, 'Transfer')
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
    result = Array.new(transaction_weeks.length, 0)

    find_transactions.each do |transaction|
      week_index = transaction_weeks.index(datetime_to_week(transaction.purchased_at))
      result[week_index] -= transaction.amount
    end

    [['Balance', rolling_sum(starting_balance, result)].flatten]
  end

  def rolling_sum(starting, sums)
    sum = starting
    sums.map { |x| sum += x }
  end
end
