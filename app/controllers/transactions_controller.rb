class TransactionsController < ApplicationController
  def index
  end

  def new
    @transaction_form = TransactionForm.new
  end
end
