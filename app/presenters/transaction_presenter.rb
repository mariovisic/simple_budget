class TransactionPresenter < ApplicationPresenter
  delegate :name, :to_param, :purchased_at, to: '@transaction'

  def initialize(transaction)
    @transaction = transaction
  end

  def name_string
    "#{amount_string} #{name} #{company}".html_safe
  end

  def budget_name
    @transaction.budget.name
  end

  def row_class
    @transaction.weekly_deposit && 'info'
  end

  private

  def amount_string
    helpers.content_tag(:strong, helpers.smart_number_to_currency(@transaction.amount))
  end

  def company
    if @transaction.company.present?
      "(#{@transaction.company})"
    end
  end
end
