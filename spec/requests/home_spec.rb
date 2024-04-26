require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'displays the forecast form' do
      get '/'
      expect(response.body).to include('Enter an address containing a zip code')
    end

    it 'displays the flash message' do
      get '/'
      # submit bad text in form
      post '/forecasts', params: { forecast: { address: '1234567890' } }
      expect(flash[:error]).to include('Zip Code must be 5 digits')
      # expect(response.body).to include('Zip Code must be 5 digits')
    end
  end
end

