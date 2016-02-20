class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :name, null: false
      t.string :company, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.datetime :purchased_at, null: false

      t.timestamps null: false
    end
  end
end
