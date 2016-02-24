class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all.order('purchased_at DESC')
  end

  def new
    @transaction_form = TransactionForm.new
  end

  def create
    @transaction_form = TransactionForm.new(transaction_params)

    if @transaction_form.save
      redirect_to root_path, flash: { notice: "Added #{@transaction_form.name}" }
    else
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:budget_id, :name, :company, :amount, :purchased_at)
  end
end
