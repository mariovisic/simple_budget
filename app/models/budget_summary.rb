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
  MINIMUM_BUDGET_PERCENTAGE = ENV.fetch('MINIMUM_BUDGET_PERCENTAGE', 0.75).to_f

  delegate :name, :weekly_deposit, to: :@budget

  def initialize(budget)
    @budget = budget
  end

  def current_state_css_class
    case weekly_spent_percentage / week_completed_percentage.to_f * 100
    when 0..80 then 'success'
    when 80..100 then 'info'
    when 100..120 then 'warning'
    else
      'danger'
    end
  end

  def remaining_days_this_week
    7 - Time.zone.now.to_date.days_to_week_start
  end

  def week_completed_percentage
    (elapsed_seconds_this_week / (60 * 60 * 24 * 7).to_f * 100).floor
  end

  def weekly_spent_percentage
    (spent_this_week / (this_week_safe_to_spend).to_f * 100).floor
  end

  def this_week_safe_to_spend
    if @budget.created_at.beginning_of_week == Time.zone.now.beginning_of_week
      balance_at_start_of_budget
    else
      [balance_at_start_of_week, MINIMUM_BUDGET_PERCENTAGE * weekly_deposit].max
    end
  end

  def balance
    -@budget.transactions.sum(:amount)
  end

  def spent_this_week
    @spent_this_week ||= [@budget.transactions.where("purchased_at > ?", Time.zone.now.beginning_of_week).where(weekly_deposit: false).sum(:amount), 0].max
  end

  def should_have_spent_this_week_so_far
    week_completed_percentage * this_week_safe_to_spend / 100.0
  end

  def has_weekly_deposit?
    weekly_deposit > 0
  end

  private

  def elapsed_seconds_this_week
    (Time.zone.now - Time.zone.now.beginning_of_week).to_i
  end

  def balance_at_start_of_week
    @balance_at_start_of_week ||= -@budget.transactions.where("purchased_at <= ?", Time.zone.now.beginning_of_week).sum(:amount)
  end

  def balance_at_start_of_budget
    @balance_at_start_of_budget ||= -@budget.transactions.first.amount
  end
end
