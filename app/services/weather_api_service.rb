module WeatherApiService
  def initialize(address = nil, zip_code)
    return nil unless zip_code.present?
  end

  def forecast
    # base_url = "https://api.weatherapi.com/v1/"
    # endpoint = forecast

    # url = "#{base_url}?zip=#{zip_code},us&appid=#{Rails.ENV.credentials.weather_api.key}"
    debugger
    url = "http://api.weatherapi.com/v1/forecast.json?key=1ae4d5a9b4f14632859203414242304&q=43017&days=5&aqi=yes&alerts=yes"
    response = HTTParty.get(url)
    response.parsed_response
  end
end

