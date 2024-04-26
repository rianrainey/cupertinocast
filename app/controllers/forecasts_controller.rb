class ForecastsController < ApplicationController
  include AddressHelper

  def create
    zip_code = parse_zip_code(params[:forecast][:address])

    if invalid_zip_code?(zip_code)
      redirect_to root_path and return
    end

    @forecast = Forecast.find_or_initialize_by(zip_code: zip_code, address: forecast_params[:address])

    if @forecast.retrieve_from_api?
      @forecast.result = get_forecast(@forecast.zip_code)
    end

    if @forecast.result["error"].nil?
      @forecast.last_search_date = Time.now
      @forecast.save
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
    params.require(:forecast).permit(
      :address,
      :zip_code,
      :result,
      :last_search_date,
    )
  end

  def invalid_zip_code?(zip_code)
   if zip_code.blank?
      flash[:error] = "Zip Code must be 5 digits. Please try again."
    end
  end
end

