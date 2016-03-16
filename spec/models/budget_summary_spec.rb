require 'rails_helper'

RSpec.describe BudgetSummary do
  describe '#week_completed_percentage' do
    let(:budget) { double }
    let(:budget_summary) { BudgetSummary.new(budget) }

    around do |example|
      old_timezone = Time.zone
      Time.zone = 'Australia/Perth'
      example.run
      Time.zone = old_timezone
    end

    it 'returns 0% at the start of the week', timecop: '2016-03-07 00:00:00 +0800' do
      expect(budget_summary.week_completed_percentage).to eq(0)
    end

    it 'returns 50% when half way through the week', timecop: '2016-03-10 12:00:00 +0800' do
      expect(budget_summary.week_completed_percentage).to eq(50)
    end

    it 'returns 99% just before the end of the week', timecop: '2016-03-13 23:59:59 +0800' do
      expect(budget_summary.week_completed_percentage).to eq(99)
    end
  end
end
