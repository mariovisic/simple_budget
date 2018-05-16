class QuickTransactionPresenter < ApplicationPresenter

  def initialize(quick_transaction)
    @quick_transaction_name = quick_transaction[0][0]
    @quick_transaction_company = quick_transaction[0][1]
  end

  def name_string
    "#{@quick_transaction_name} #{company}".html_safe
  end

  def attributes
    { transaction: {
      name: @quick_transaction_name,
      company: @quick_transaction_company,
    } }
  end

  private

  def company
    if @quick_transaction_company.present?
      "(#{@quick_transaction_company})"
    end
  end
end
