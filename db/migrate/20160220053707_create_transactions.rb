class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name, null: false
      t.string :company, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.datetime :purchased_at, null: false
      t.boolean :weekly_deposit, null: false, default: false
      t.integer :budget_id, null: false

      t.timestamps null: false
    end

    add_index :transactions, :budget_id
  end
end
