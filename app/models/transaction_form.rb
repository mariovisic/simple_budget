class TransactionForm
  include ActiveModel::Model

  attr_accessor :id, :name, :company, :amount, :purchased_at, :created_at, :updated_at, :budget_id, :weekly_deposit
  validates :name, :amount, :purchased_at, presence: true
  validates :amount, numericality: true
  validate :ensure_purchased_at_not_after_the_week

  def save
    valid? && persist_budget
  end

  def persisted?
    id.present?
  end

  def persist_budget
    if persisted?
      Transaction.find(id).update_attributes!(attributes)
    else
      Transaction.create!(attributes)
    end
  end

  def attributes
    { budget_id: budget_id, name: name.try(:strip), company: company.try(:strip), amount: amount, purchased_at: purchased_at }
  end

  def model_name
    Transaction.model_name
  end

  def budget_options
    Budget.all.map { |budget| [budget.name, budget.id] }
  end

  private

  def ensure_purchased_at_not_after_the_week
    parsed_purchased_at_date = Date.parse(purchased_at) rescue nil

    if parsed_purchased_at_date.present? && parsed_purchased_at_date > Time.now.utc.end_of_week
      errors.add(:purchased_at, 'cannot be after the week')
    end
  end
end
