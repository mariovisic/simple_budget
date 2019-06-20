class BudgetPresenter < ApplicationPresenter
  def initialize(budget)
    @budget = budget
  end

  def to_json
    ({
      data: {
        columns: totals + transaction_mapping,
        type: 'bar',
        types: { 'Total' => 'line' },
        groups: [transaction_names]
      },
      bindto: "#weekly-budget-graph-#{@budget.id}",
      axis: {
        x: {
          type: 'category',
          categories: ['Total'] + transaction_weeks
        },
      }
    }).to_json.html_safe
  end

  private

  def find_transactions
    @transactions ||= @budget.transactions.where('amount > ? AND created_at > ? AND name != ?', 0, 6.months.ago, 'Transfer')
  end


  def transaction_weeks
    @transaction_weeks ||= (find_transactions.map do |transaction|
      datetime_to_week(transaction.created_at)
    end).uniq
  end

  def transaction_names
    @transaction_names ||= find_transactions.map(&:name).uniq
  end

  def transaction_mapping
    mapping = transaction_names.map do |name|
      [name, Array.new(transaction_weeks.length)].flatten
    end

    find_transactions.each do |transaction|
      name_index = transaction_names.index(transaction.name)
      week_index = transaction_weeks.index(datetime_to_week(transaction.created_at)) + 1

      mapping[name_index][week_index] ||= 0
      mapping[name_index][week_index] += transaction.amount
    end

    mapping
  end

  private

  def datetime_to_week(datetime)
    datetime.beginning_of_week.strftime("%d %b %Y")
  end

  def totals
    result = Array.new(transaction_weeks.length, 0)

    find_transactions.each do |transaction|
      week_index = transaction_weeks.index(datetime_to_week(transaction.created_at))

      result[week_index] += transaction.amount
    end

    [['Total', result].flatten]
  end
end
