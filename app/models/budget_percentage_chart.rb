class BudgetPercentageChart
  def initialize(budget_summary)
    @budget_summary = budget_summary
  end

  def to_h
    Hash.new.tap do |data|
      data[:info] = { amount: spent_amount.to_s, percentage: calculate_percentage_for(spent_amount) }

      if overspend.negative?
        data[:success] = { amount: overspend.abs.to_s, percentage: calculate_percentage_for(overspend.abs)}
      else
        data[:danger] = { amount: overspend.to_s, percentage: 100 - calculate_percentage_for((spent_amount + [remaining, 0].max)) }
      end

      if remaining.positive?
        data[:remaining] = { amount: remaining.to_s, percentage: calculate_percentage_for(remaining) }
      end
    end
  end

  private

  def overspend
    @overspend ||= @budget_summary.spent_this_week - @budget_summary.should_have_spent_this_week_so_far
  end

  def spent_amount
    @spent_amount ||= @budget_summary.spent_this_week - [overspend, 0].max
  end

  def remaining
    @remaining ||= @budget_summary.this_week_safe_to_spend - spent_amount - overspend.abs
  end

  def safe_to_spend_amount
    @safe_to_spend_amount ||= @budget_summary.this_week_safe_to_spend.to_f
  end

  def calculate_percentage_for(value)
    (value / safe_to_spend_amount * 100).round(2)
  end
end
