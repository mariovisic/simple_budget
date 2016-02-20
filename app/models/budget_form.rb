class BudgetForm
  include ActiveModel::Model

  attr_accessor :name, :weekly_deposit
  validates :name, :weekly_deposit, presence: true
  validates :weekly_deposit, numericality: { greater_than_or_equal_to: 0 }

  def save
    valid? && Budget.create!(attributes)
  end

  def attributes
    { name: name, weekly_deposit: weekly_deposit }
  end

  def model_name
    Budget.model_name
  end
end
