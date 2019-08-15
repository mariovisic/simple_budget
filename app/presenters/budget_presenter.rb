include ActionView::Helpers::NumberHelper

class BudgetPresenter < ApplicationPresenter
  LARGE_TRANSACTION_THRESHOLD = 200

  def to_json
    puts '1'
    puts balances.inspect
    puts '2'
    puts balances.to_json.inspect
    puts '3'
    #puts balances.to_json.html_safe.inspect
    #balances.to_json.html_safe
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
    @transactions ||= Transaction.where('purchased_at > ? AND purchased_at < ? AND name != ?', 6.months.ago, 1.week.ago.end_of_week, 'Transfer').order(:purchased_at)
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
      [transaction_weeks[index], amount.to_f, "<p>Balance: #{number_to_currency(amount)}</p> #{large_transaction_text(data[:large_transactions])}".html_safe]
    end
   end

  def large_transaction_text(transactions)
    if transactions.present?
      "<p><strong>Large Transactions:</strong><br>" + (transactions.map do |transaction|
        "&nbsp;&nbsp;#{transaction.name}: #{number_to_currency(transaction.amount)}"
      end).join("<br>") + "</p>"
    end
  end
end
