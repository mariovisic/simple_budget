class TransactionForm
  include ActiveModel::Model

  attr_accessor :id, :name, :company, :amount, :purchased_at, :created_at, :updated_at, :budget_id
  validates :name, :company, :amount, :purchased_at, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

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
    { }
    # FIXME
  end

  def model_name
    Transaction.model_name
  end

  def budget_options
    Budget.all.map { |budget| [budget.name, budget.id] }
  end
end
