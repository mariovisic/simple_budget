class AddIndexToTransactionsWeeklyDeposit < ActiveRecord::Migration
  def change
    add_index :transactions, :weekly_deposit
  end
end
