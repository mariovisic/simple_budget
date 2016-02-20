class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :name, null: false
      t.decimal :weekly_deposit, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
