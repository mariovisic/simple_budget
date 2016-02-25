class BudgetSummary
  # TODO: Needs more thought.
  #
  # If the weekly deposit amount in a budget isn't available at the start of
  # the week due to previous debts, if it's less than 75% of the weekly
  # deposit, then use 75% as the minimum value. This means that we'll slowly be
  # guided back on track by aiming to spend 75% of the deposit money rather
  # than the full amount.
  #
  # The alternatives are to just avoid dealing with budgets that are negative
  # amounts at the start of the week and to deal with lower value budgets.
  #
  # Although I think this approach is better as we're not flying blind
  #
  MINIMUM_BUDGET_PERCENTAGE = 0.75

  delegate :name, :weekly_deposit, to: :@budget

  def initialize(budget)
    @budget = budget
  end

  def current_state_css_class
    case weekly_spent_percentage / week_completed_percentage.to_f * 100
    when 0..90 then 'success'
    when 90..100 then 'info'
    when 100..110 then 'warning'
    else
      'danger'
    end
  end

  def remaining_days_this_week
    (remaining_seconds_this_week / (60 * 60 * 24).to_f).ceil
  end


  def week_completed_percentage
    (remaining_seconds_this_week / seconds_in_a_week.to_f * 100).round
  end

  def weekly_spent_percentage
    (spent_this_week / (this_week_safe_to_spend).to_f * 100).round
  end

  def this_week_safe_to_spend
    if @budget.created_at > 7.days.ago
      balance_at_start_of_budget
    else
      [balance_at_start_of_week, MINIMUM_BUDGET_PERCENTAGE * weekly_deposit].max
    end
  end

  # TODO: Pull out percentage chart to a new class I think !!!
  # TODO: Figure out how this works? LOL MATH!
  def percentage_chart_data
    data = Hash.new.tap do |data|
      data[:info] = { amount: [spent_this_week.to_f, 0].max.to_f, percentage: [weekly_spent_percentage, week_completed_percentage].min  }
      if week_completed_percentage > weekly_spent_percentage
        info_percentage = (week_completed_percentage - weekly_spent_percentage)
        data[:success] = { amount: info_percentage / 100.0 * this_week_safe_to_spend.to_f, percentage: info_percentage }
      else
        data[:danger] = { amount: (weekly_spent_percentage - week_completed_percentage) / 100.0 * this_week_safe_to_spend.to_f, percentage: [weekly_spent_percentage - week_completed_percentage, 100 - data[:info][:percentage] ].min }
        data[:info][:amount] = (data[:info][:amount] - data[:danger][:amount])
      end

      if weekly_spent_percentage < 100
        data[:remaining] = { amount: -(spent_this_week - this_week_safe_to_spend), percentage: 100 - data[:info][:percentage] - (data[:success].try(:[], :percentage) || 0) - (data[:danger].try(:[], :percentage) || 0) }
      end
    end
  end

  def balance
    -@budget.transactions.sum(:amount)
  end

  def spent_this_week
    @spent_this_week ||= @budget.transactions.where("purchased_at > ?", Time.now.beginning_of_week).where(weekly_deposit: false).sum(:amount)
  end

  private

  def seconds_in_a_week
    60 * 60 * 24 * 7
  end

  def remaining_seconds_this_week
    (Time.now.next_week - Time.now).to_i
  end

  def balance_at_start_of_week
    @balance_at_start_of_week ||= -@budget.transactions.where("purchased_at <= ?", Time.now.beginning_of_week).sum(:amount)
  end

  def balance_at_start_of_budget
    @balance_at_start_of_budget ||= @budget.transactions.first.amount
  end
end
