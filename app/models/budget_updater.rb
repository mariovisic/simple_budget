class BudgetUpdater
  WEEKLY_DEPOSIT_NAME = 'Weekly Deposit'
  INITIAL_DEPOSIT_NAME = 'Initial Deposit'

  def self.update_all
    Budget.all.each { |budget| new(budget).update }
  end

  def initialize(budget)
    @budget = budget
  end

  def update
    create_initial_deposit
    create_missing_deposits
  end

  private

  def create_initial_deposit
    if last_deposit_time.blank?
      @budget.transactions.create!({
        name: INITIAL_DEPOSIT_NAME,
        amount: -@budget.weekly_deposit * days_remaining_first_week / 7,
        purchased_at: @budget.created_at, weekly_deposit: true
      })
    end
  end

  def days_remaining_first_week
    7 - @budget.created_at.days_to_week_start
  end

  def create_missing_deposits
    weekly_deposit_days.each do |time|
      @budget.transactions.create!({
        name: WEEKLY_DEPOSIT_NAME,
        amount: -@budget.weekly_deposit,
        purchased_at: time,
        weekly_deposit: true
      })
    end
  end

  def weekly_deposit_days
    (last_deposit_time.tomorrow.to_date..Time.zone.now.to_date).select(&:monday?).map { |date| date.to_time.beginning_of_day }
  end

  def last_deposit_time
    @last_deposit_time ||= @budget.transactions.where(weekly_deposit: true).order('purchased_at desc').first.try(:purchased_at)
  end
end
