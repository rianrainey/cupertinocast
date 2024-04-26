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
      end

      context 'when the API key is invalid' do
        subject { post '/forecasts', params: { forecast: { address: '94101' } } }

        it 'display error message' do
          allow_any_instance_of(WeatherApiService).to receive(:forecast).and_return(error_response)
          subject
          expect(flash[:error]).to include("API key is invalid or not provided.")
        end
      end
    end

    context 'when address is invalid' do
      it 'returns http error' do
        post '/forecasts', params: { forecast: { address: '941011' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to include("Zip Code must be 5 digits")
      end
    end
  end
end

