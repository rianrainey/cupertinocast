require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe '#retrieve_from_api?' do
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
        expect(forecast.retrieve_from_api?).to eq(false)
      end
    end

    context 'recent forecast does not exist' do
      it 'returns false' do
        forecast.update(last_search_date: not_recent_time)
        expect(forecast.retrieve_from_api?).to eq(true)
      end
    end
  end
end
