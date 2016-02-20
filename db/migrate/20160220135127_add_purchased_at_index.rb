class AddPurchasedAtIndex < ActiveRecord::Migration
  def change
    add_index :transactions, :purchased_at
  end
end
