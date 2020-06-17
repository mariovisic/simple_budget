class TransactionForm
  include ActiveModel::Model

  attr_accessor :id, :name, :company, :amount, :created_at, :updated_at, :budget_id, :weekly_deposit
  attr_writer :purchased_at
  validates :name, :amount, :purchased_at, presence: true
  validates :amount, numericality: true
  validate :ensure_purchased_at_not_after_the_week

  def purchased_at
    @purchased_at && Time.zone.parse(@purchased_at.to_s)
  end

  def save
    valid? && persist_transaction
  end

  def persisted?
    id.present?
  end

  def persist_transaction
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
    Budget.all.order(:id).map { |budget| [budget.name, budget.id] }
  end

  private

  def ensure_purchased_at_not_after_the_week
    parsed_purchased_at_date = Time.zone.parse(purchased_at.to_s).to_date rescue nil

    if parsed_purchased_at_date.present? && parsed_purchased_at_date > Time.zone.now.end_of_week
      errors.add(:purchased_at, 'cannot be after the week')
    end
  end
end
