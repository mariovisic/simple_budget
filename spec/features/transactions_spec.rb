require 'rails_helper'

RSpec.feature 'Transactions' do
  let!(:budget) { create(:budget) }

  scenario 'Creating a transaction' do
    visit root_path
    click_link 'New Transaction'

    fill_in 'Name', with: 'Coffee'
    fill_in 'Purchased at', with: Time.now
    fill_in 'Company', with: 'Boombap'
    fill_in 'Amount', with: '3.20'
    click_button 'Create Transaction'

    expect(page).to have_content('Added Coffee')
  end

  scenario 'Viewing the list of recent transactions' do
    create(:transaction, name: 'Groceries', company: 'Woolworths', amount: 3.2, budget_id: budget.id)

    visit root_path
    click_link 'Transactions'

    expect(page).to have_content('Groceries')
    expect(page).to have_content('Woolworths')
    expect(page).to have_content('$3.20')
  end

  scenario 'Viewing a list of all of the transactions' do
    allow(Rails.application.config).to receive(:default_num_transactions_to_show).and_return(1)
    create(:transaction, name: 'Groceries', company: 'Woolworths', amount: 3.2, budget_id: budget.id)
    create(:transaction, name: 'Groceries', company: 'Coles',      amount: 4.0, budget_id: budget.id)

    visit root_path
    click_link 'Transactions'
    expect(page).to have_no_content('Woolworths')

    click_link 'Show all transactions'
    expect(page).to have_content('Woolworths')
  end

  scenario 'editing a transaction' do
    purchased_at = Time.zone.parse('Wed, 17 Jun 2020 01:25:00 UTC +00:00')
    transaction = create(:transaction, name: 'Grozeries', company: 'Woolzorths', amount: 17.20, budget_id: budget.id, purchased_at: purchased_at)

    visit root_path
    click_link 'Transactions'
    click_link 'Grozeries'

    fill_in 'Name', with: 'Groceries'
    fill_in 'Company', with: 'Woolworths'
    click_button 'Update Transaction'

    expect(page).to have_content('Grozeries updated')
    expect(transaction.reload.name).to eq('Groceries')
    expect(transaction.reload.company).to eq('Woolworths')
    expect(transaction.reload.purchased_at).to eq(purchased_at)
  end
end
