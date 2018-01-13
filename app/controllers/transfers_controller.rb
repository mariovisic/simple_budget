class TransfersController < ApplicationController
  def new
    @transfer_form = TransferForm.new
  end

  def create
    @transfer_form = TransferForm.new(transfer_params)

    if @transfer_form.save
      redirect_to root_path, flash: { notice: "Created Transfer" }
    else
      render :new
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit(:from_budget_id, :to_budget_id, :transfer_at, :amount)
  end
end
