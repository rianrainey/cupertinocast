class ForecastsController < ApplicationController
  include AddressHelper
  include WeatherApiService

  def show
    @address = params[:address]
    # @zip_code = params[:zip_code]
    @zip_code = parse_zip_code(@address)

    unless @zip_code
      flash[:error] = "Zip Code must be 5 digits. Please try again."
      redirect_to root_path
    end

    # save address and zip code to the database after validation

    # call the forecast service
    response = WeatherApiService.forecast(@address, @zip_code)
  end
end

