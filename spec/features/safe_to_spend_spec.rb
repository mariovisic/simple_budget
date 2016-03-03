require 'rails_helper'

RSpec.feature 'Safe to spend' do
  let!(:budget) { create(:budget, weekly_deposit: 100, created_at: Date.new(2015, 1, 1).beginning_of_week) }
  let!(:initial_transaction) { create(:transaction, amount: spent, budget: budget, purchased_at: budget.created_at) }

  context 'when the budget has the full amount at the start of the week' do
    let(:spent) { 100 }

    scenario 'It uses the full amount' do
      Timecop.freeze(budget.created_at + 1.week) do
        visit root_path
        expect(page).to have_content('$0 / $100 spent this week.')
      end
    end
  end

  context 'when the budget has more than 75% of the full amount at the start of the week' do
    let(:spent) { 120 }

    scenario 'It uses the remaining amount' do
      Timecop.freeze(budget.created_at + 1.week) do
        visit root_path
        expect(page).to have_content('$0 / $80 spent this week.')
      end
    end
  end

  context 'when the budget has less than 75% of the full amount at the start of the week' do
    let(:spent) { 180 }

    scenario 'It uses 75% of the weekly deposit amount' do
      Timecop.freeze(budget.created_at + 1.week) do
        visit root_path
        expect(page).to have_content('$0 / $75 spent this week.')
      end
    end
  end
end
