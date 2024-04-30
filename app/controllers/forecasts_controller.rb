class ForecastsController < ApplicationController
  include AddressHelper

  def create
    zip_code = parse_zip_code(params[:forecast][:address])
    if zip_code.blank?
      flash[:error] = "Zip Code must be 5 digits. Please try again."
      redirect_to root_path and return
    end

    # debugger
    @forecast = Forecast.find_or_initialize_by(zip_code: zip_code, address: forecast_params[:address])

    if @forecast.outdated? || @forecast.result.nil?
      @forecast.result = get_forecast(@forecast.zip_code)
      @forecast.last_search_date = Time.zone.now
    elsif @forecast.result.present?
      flash[:notice] = "Results are cached from the last 30 minutes."
    else
      raise StandardError, "Error retrieving weather data"
    end

    if @forecast.result&.key?('error')
      flash[:error] = @forecast.result["error"]["message"]
      redirect_to root_path and return
    end

    if @forecast.save || @forecast.result.present?
      redirect_to @forecast
    else
      flash[:error] = "Something went wrong. Please try again."
      redirect_to root_path
    end
  end

  def show
    @forecast = Forecast.find(params[:id])
  end

  def new
    @forecast = Forecast.new
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
end

