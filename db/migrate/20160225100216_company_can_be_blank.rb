class CompanyCanBeBlank < ActiveRecord::Migration
  def change
    change_column :transactions, :company, :string, null: true
  end
end
