require 'rails_helper'

RSpec.feature 'Transfers' do
  let!(:budget_one) { create(:budget, name: 'Spendings') }
  let!(:budget_two) { create(:budget, name: 'Savings') }

  scenario 'Creating a transfer' do
    Transaction.create!(budget: budget_one, amount: -400, name: 'Initial funds deposit', purchased_at: Time.now)

    visit root_path
    click_link 'Transfer'

    select 'Spendings', from: 'From'
    select 'Savings', from: 'To'
    fill_in 'Amount', with: '100'
    fill_in 'Transfer at', with: Time.now
    click_button 'Create Transfer'

    expect(page).to have_content('Created Transfer')

    # Remove the initial deposit transactions, as they'll vary depending on the time of the week
    # We only want the initial transaction above and the two that are created from the transfer :)
    Transaction.where(name: 'Initial Deposit').delete_all
    expect(BudgetSummary.new(budget_one).balance).to eq(300)
    expect(BudgetSummary.new(budget_two).balance).to eq(100)
  end
end
