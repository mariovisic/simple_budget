class BudgetForm
  include ActiveModel::Model

  attr_accessor :id, :name, :weekly_deposit, :created_at, :updated_at

  validates :name, :weekly_deposit, presence: true
  validates :weekly_deposit, numericality: { greater_than_or_equal_to: 0 }

  def save
    valid? && persist_budget
  end

  def persisted?
    id.present?
  end

  def persist_budget
    if persisted?
      Budget.find(id).update_attributes!(attributes)
    else
      Budget.create!(attributes)
    end
  end

  def attributes
    { name: name.try(:strip), weekly_deposit: weekly_deposit }
  end

  def model_name
    Budget.model_name
  end
end
