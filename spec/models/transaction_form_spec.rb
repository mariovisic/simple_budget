require 'rails_helper'

RSpec.describe TransactionForm do
  context 'validation' do
    context 'purchased_at' do
      let(:transaction_form) { TransactionForm.new(purchased_at: purchased_at) }

      before { transaction_form.valid? }

      context 'when the purchased at time is in the current week' do
        let(:purchased_at) { Time.now }

        it 'is valid' do
          expect(transaction_form.errors[:purchased_at]).to be_blank
        end
      end

      context 'when the purchased at time is in a past week' do
        let(:purchased_at) { 2.weeks.ago }

        it 'is valid' do
          expect(transaction_form.errors[:purchased_at]).to be_blank
        end
      end

      context 'when the purchased at time is in a future week' do
        let(:purchased_at) { 2.weeks.from_now }

        it 'is valid' do
          expect(transaction_form.errors[:purchased_at]).to eq(Array('cannot be after the week'))
        end
      end

      context 'when the purchased at time is this week but UTC time is last week', timecop: '2016-03-07 02:00:00 +1100' do
        let(:early_monday_morning) { Time.parse('2016-03-07 02:00:00 +1100') }
        let(:purchased_at) { early_monday_morning }

        it 'is valid' do
          expect(transaction_form.errors[:purchased_at]).to be_blank
        end
      end

      context 'when the purchased at time is this week but UTC time is next week', timecop: '2016-03-06 22:00:00 +1100' do
        let(:late_sunday_night) { Time.parse('2016-03-06 22:00:00 +1100') }
        let(:purchased_at) { late_sunday_night }

        it 'is valid' do
          expect(transaction_form.errors[:purchased_at]).to be_blank
        end
      end
    end
  end
end
