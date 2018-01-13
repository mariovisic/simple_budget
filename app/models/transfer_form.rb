class TransferForm
  TRANSACTION_NAME = 'Transfer'
  include ActiveModel::Model

  attr_accessor :id, :amount, :transfer_at, :created_at, :updated_at, :to_budget_id, :from_budget_id, :weekly_deposit
  validates  :amount, :transfer_at, presence: true
  validates :amount, numericality: true
  validate :ensure_transfer_at_not_after_the_week
  validate :ensure_budgets_are_not_the_same

  def save
    valid? && persist_transfer
  end

  def persisted?
    id.present?
  end

  def persist_transfer
    Transaction.transaction do
      Transaction.create!(transaction_one_attributes)
      Transaction.create!(transaction_two_attributes)
    end
  end

  def transaction_one_attributes
    { budget_id: from_budget_id, name: TRANSACTION_NAME, amount: amount, purchased_at: transfer_at }
  end

  def transaction_two_attributes
    { budget_id: to_budget_id, name: TRANSACTION_NAME, amount: "-#{amount}", purchased_at: transfer_at }
  end

  def model_name
    ActiveModel::Name.new(OpenStruct.new(name: 'transfer'))
  end

  def budget_options
    Budget.all.map { |budget| [budget.name, budget.id] }
  end

  private

  def ensure_transfer_at_not_after_the_week
    parsed_transfer_at_date = Time.zone.parse(transfer_at.to_s).to_date rescue nil

    if parsed_transfer_at_date.present? && parsed_transfer_at_date > Time.zone.now.end_of_week
      errors.add(:transfer_at, 'cannot be after the week')
    end
  end

  def ensure_budgets_are_not_the_same
    if to_budget_id == from_budget_id
      errors.add(:to_budget_id, 'cannot transfer to/from the same budget')
    end
  end
end
