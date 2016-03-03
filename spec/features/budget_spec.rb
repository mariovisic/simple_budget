require 'rails_helper'

RSpec.feature 'Budgets' do
  scenario 'Creating a budget' do
    visit root_path
    click_link 'Budgets'
    click_link 'New Budget'

    fill_in 'Name', with: 'Food'
    fill_in 'Weekly deposit', with: '100.20'
    click_button 'Create Budget'

    expect(page).to have_content('Budget created')
  end
end
