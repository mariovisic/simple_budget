require 'rails_helper'

RSpec.describe BudgetPercentageChart do
  describe '#to_h' do
    let(:budget) { instance_double(BudgetSummary, spent_this_week: 210,
                                   this_week_safe_to_spend: 750,
                                   should_have_spent_this_week_so_far: should_have_spent_this_week_so_far) }
    let(:budget_percentage_data) { BudgetPercentageChart.new(budget) }
    let(:should_have_spent_this_week_so_far) { 360 }

    it 'returns the budget already spent against the "info" key' do
      expect(budget_percentage_data.to_h[:info]).to eq(amount: '210', percentage: 28)
    end

    context 'when we are within the safe to spend' do
      let(:should_have_spent_this_week_so_far) { 360 }

      it 'returns the remaining safe to spend budget against the "success" key' do
        expect(budget_percentage_data.to_h[:success]).to eq(amount: '150', percentage: 20)
      end
    end

    context 'when we are over the safe to spend' do
      let(:should_have_spent_this_week_so_far) { 60 }

      it 'returns the over budget amount against the "danger" key' do
        expect(budget_percentage_data.to_h[:danger]).to eq(amount: '150', percentage: 20)
      end
    end

    context 'when there is budget remaining' do
      it 'returns the remaining budget against the "remaining" key' do
        expect(budget_percentage_data.to_h[:remaining]).to eq(amount: '390', percentage: 52)
      end
    end
  end
end
