class ForecastsController < ApplicationController
  include AddressHelper

  def create
    @forecast = Forecast.new(forecast_params)
    @forecast.zip_code = parse_zip_code(@forecast.address)

    unless @forecast.zip_code
      flash[:error] = "Zip Code must be 5 digits. Please try again."
      redirect_to root_path and return
    end

    # debugger
    @forecast.result = get_forecast(@forecast.zip_code)
    if @forecast.result["error"].nil? && @forecast.save
      redirect_to @forecast
    else
      flash[:error] = @forecast.result["error"]["message"]
      redirect_to root_path
    end
  end

  def show
    @forecast = Forecast.find(params[:id])
  end

  private

  def get_forecast(zip_code)
    weather_api = WeatherApiService.new(zip_code)
    weather_api.forecast
  end

  def forecast_params
    params.require(:forecast).permit(:address, :zip_code, :result)
  end
end

