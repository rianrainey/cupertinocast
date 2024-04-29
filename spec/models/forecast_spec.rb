require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe '#outdated?' do
    before do
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    # use factory bot to create basic forecast
    let(:forecast) { create(:forecast) }
    let(:recent_time) { Time.zone.now-30.minutes }
    let(:not_recent_time) { Time.zone.now-30.minutes-1.second }

    context 'recent forecast exists' do
      it 'returns true' do
        forecast.update(last_search_date: recent_time)
        expect(forecast.outdated?).to eq(false)
      end
    end

    context 'recent forecast does not exist' do
      it 'returns false' do
        forecast.update(last_search_date: not_recent_time)
        expect(forecast.outdated?).to eq(true)
      end
    end
  end

  describe 'validations' do
    context 'zip code is valid' do
      subject { build(:forecast, zip_code: '12345') }

      it { is_expected.to be_valid }
    end

    context 'zip code is invalid' do
      let(:invalid_zip_codes) {
        [
          build(:forecast, zip_code: ''),
          build(:forecast, zip_code: '1234'),
          build(:forecast, zip_code: '123456'),
          build(:forecast, zip_code: '1234a'),
          build(:forecast, zip_code: '12345-6789'),
        ]
      }

      it 'returns invalid' do
        invalid_zip_codes.each do |forecast|
          expect(forecast).to be_invalid
        end
      end

    end
  end
end
