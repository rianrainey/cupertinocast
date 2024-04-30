require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'POST /create' do
    let(:success_response) { {'location' => { 'name' => 'Dublin' } } }
    let(:success_response_api) { {'location' => { 'name' => 'New York' } } }
    let(:error_response) { {'error'=>{'code'=>1002, 'message'=>'API key is invalid or not provided.'}} }
    let(:flash_error) { "Results are cached from the last 30 minutes." }
    let(:now) { Time.zone.now }
    let(:outdated_time_window) { now - 30.minutes - 1.second }
    let(:forecast) {
      create(:forecast,
        address: '12345',
        zip_code: '12345',
      )
    }

    context 'when the address is valid' do
      subject { post '/forecasts', params: { forecast: { address: '12345' } } }

      it 'returns http success' do
        Timecop.freeze(now)
        allow_any_instance_of(WeatherApiService).to receive(:forecast).and_return(success_response)
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(forecast_path(assigns(:forecast)))
        expect(assigns(:forecast).address).to eq('12345')
        expect(assigns(:forecast).zip_code).to eq('12345')
        expect(assigns(:forecast).last_search_date).to eq(now)
        expect(assigns(:forecast).result).to eq(success_response)
        Timecop.return
      end

      context 'and results are not outdated' do
        before do
          forecast.update(last_search_date: now)
        end

        context 'when the forecast result is in the database' do
          before do
            forecast.update(result: success_response)
          end

          it 'does not call api' do
            expect_any_instance_of(WeatherApiService).not_to receive(:forecast)
            subject
            follow_redirect!
            expect(response.body).to include(flash_error)
            expect(response.body).to include('Dublin')
          end
        end

        context 'when the forecast result is not in the database' do
          before do
            forecast.update(result: nil)
          end

          it 'calls the api' do
            expect_any_instance_of(WeatherApiService).to receive(:forecast).and_return(success_response_api)
            subject
            follow_redirect!
            expect(response.body).not_to include(flash_error)
            expect(response.body).to include('New York')
          end
        end
      end

      context 'and zip code results are outdated' do
        before do
          forecast.update(last_search_date: outdated_time_window)
        end

        context 'when the forecast is in the database' do
          it 'calls the api' do
            Timecop.freeze(now)
            expect_any_instance_of(WeatherApiService).to receive(:forecast).and_return(success_response_api)
            subject
            follow_redirect!
            expect(response.body).to include('New York')
            expect(forecast.reload.last_search_date).to eq(now)
            Timecop.return
          end
        end

        context 'when the forecast is not in the database' do
          before do
            forecast.update(result: nil)
          end

          it 'calls the api' do
            Timecop.freeze(now)
            expect_any_instance_of(WeatherApiService).to receive(:forecast).and_return(success_response_api)
            subject
            follow_redirect!
            expect(response.body).to include('New York')
            expect(forecast.reload.last_search_date).to eq(now)
            Timecop.return
          end
        end
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
      subject { post '/forecasts', params: { forecast: { address: '1234' } } }

      it 'returns http error' do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to include("Zip Code must be 5 digits")
      end
    end

  end
end

