class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.includes(:budget).all.limit(transactions_limit).order('purchased_at DESC', 'id DESC').map { |transaction| TransactionPresenter.new(transaction) }
  end

  def new
    @transaction_form = TransactionForm.new(optional_transaction_params)
  end

  def create
    @transaction_form = TransactionForm.new(transaction_params)

    if @transaction_form.save
      redirect_to root_path, flash: { notice: "Added #{@transaction_form.name}" }
    else
      render :new
    end
  end

  def edit
    transaction = Transaction.find(params[:id])

    @transaction_form = TransactionForm.new(transaction.attributes)
  end

  def update
    transaction = Transaction.find(params[:id])
    @transaction_form = TransactionForm.new(transaction.attributes.merge(transaction_params))

    if @transaction_form.save
      redirect_to transactions_path, flash: { notice: "#{transaction.name} updated" }
    else
      render :new
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    redirect_to transactions_path, flash: { notice: "#{@transaction.name} deleted" }
  end

  private

  def optional_transaction_params
    if params.has_key?(:transaction)
      params.require(:transaction).permit(:budget_id, :name, :company, :amount, :purchased_at)
    end
  end

  def transaction_params
    params.require(:transaction).permit(:budget_id, :name, :company, :amount, :purchased_at)
  end

  def transactions_limit
    params.has_key?(:all) ? nil : Rails.application.config.default_num_transactions_to_show
  end
end
