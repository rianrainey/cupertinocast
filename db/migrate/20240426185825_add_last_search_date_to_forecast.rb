class AddLastSearchDateToForecast < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :last_search_date, :datetime
  end
end
