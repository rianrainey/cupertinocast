class AddJsonToForecast < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :result, :json
  end
end
