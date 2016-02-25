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
    @transaction.weekly_deposit && 'active'
  end

  private

  def amount_string
    helpers.content_tag(:strong, amount_plus_minus_sign + helpers.smart_number_to_currency(@transaction.amount.abs), class: amount_text_css_class)
  end

  def amount_plus_minus_sign
    if @transaction.amount.positive?
      "-"
    else
      "+"
    end
  end

  def amount_text_css_class
    if @transaction.amount.positive?
      'text-danger'
    else
      'text-success'
    end
  end

  def company
    if @transaction.company.present?
      "(#{@transaction.company})"
    end
  end
end
