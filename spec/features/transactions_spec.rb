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
end
