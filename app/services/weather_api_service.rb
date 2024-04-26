class WeatherApiService
  include HTTParty
  format :json
  base_uri Rails.application.credentials.weather_api.uri
  default_params key: Rails.application.credentials.weather_api.api_key

  FORECAST_DAYS = 5
  FORECAST_ALERTS = 'yes'

  def initialize(query)
    raise ArgumentError, 'Zip Code is required' if query.blank?
    @options = {
      query: {
        q: query,
        days: FORECAST_DAYS,
        alerts: FORECAST_ALERTS
      }
    }
  end

  def forecast
    base_url = "#{@uri}/forecast.json?"
    response = self.class.get(base_url, @options)
    response.parsed_response
  end
end

