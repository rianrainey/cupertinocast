class HomeController < ApplicationController
  def index
    # take input from the form
    @forecast = Forecast.new
  end
end

