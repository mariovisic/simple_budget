require 'rails_helper'

RSpec.describe CurrentTimeZone do
  describe '#set' do
    context 'when the timezone is valid' do
      it 'sets the current timezone' do
        CurrentTimeZone.set('Australia/Melbourne')

        expect(CurrentTimeZone.to_s).to eq('Australia/Melbourne')
      end
    end

    context 'when the timezone is not valid' do
      it 'keeps the existing timezone' do
        CurrentTimeZone.set('Australia/Melbourne')
        CurrentTimeZone.set('totally not valid/foo')

        expect(CurrentTimeZone.to_s).to eq('Australia/Melbourne')
      end
    end
  end

  describe '#to_s' do
    it 'uses the rails timezone by default' do
      allow(Rails.configuration).to receive(:time_zone).and_return('the default one')
      CurrentTimeZone.reset

      expect(CurrentTimeZone.to_s).to eq('the default one')
    end

    it 'displays the current timezone' do
      CurrentTimeZone.set('Africa/Kigali')

      expect(CurrentTimeZone.to_s).to eq('Africa/Kigali')
    end
  end
end
