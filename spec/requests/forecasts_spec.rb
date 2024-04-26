require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'POST /create' do
    let(:success_response) { {'location' => { 'name' => 'Dublin' } } }
    let(:error_response) { {'error'=>{'code'=>1002, 'message'=>'API key is invalid or not provided.'}} }

    context 'when the address is valid' do
      subject { post '/forecasts', params: { forecast: { address: '94101' } } }

      it 'returns http success' do
        allow_any_instance_of(WeatherApiService).to receive(:forecast).and_return(success_response)
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(forecast_path(assigns(:forecast)))
        expect(assigns(:forecast).address).to eq('94101')
        expect(assigns(:forecast).zip_code).to eq('94101')
        expect(assigns(:forecast).last_search_date).to be
      end

      context 'and the API key is invalid' do
        it 'display error message' do
          allow_any_instance_of(WeatherApiService).to receive(:forecast).and_return(error_response)
          subject
          expect(flash[:error]).to include("API key is invalid or not provided.")
        end
      end
    end

    context 'when address is invalid' do
      subject { post '/forecasts', params: { forecast: { address: '941011' } } }

      it 'returns http error' do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to include("Zip Code must be 5 digits")
      end
    end

    context 'zip code results are less than 30 minutes old' do
      subject { post '/forecasts', params: { forecast: { address: '94101' } } }

      it 'returns from cache and not api' do
        recent_time_window = Time.zone.now
        expect_any_instance_of(WeatherApiService).not_to receive(:forecast)
        forecast = create(:forecast, address: '94101', zip_code: '94101', last_search_date: Time.zone.now, result: success_response)
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(forecast_path(assigns(:forecast)))
      end
    end

    context 'and searched more than 30 minutes ago' do
      it 'returns from api and not cache' do
        now = Time.now
        expect_any_instance_of(WeatherApiService).to receive(:forecast)
        forecast = create(:forecast, address: '94101', zip_code: '94101', last_search_date: Time.now - 30.minutes - 1.second)
        subject
        debugger
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(forecast_path(assigns(:forecast)))
        # it updates last_search_date
        expect(forecast.last_search_date).to be(now)
      end
    end


  end
end

