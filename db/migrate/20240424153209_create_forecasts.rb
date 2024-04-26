class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.string :zip_code # make this required
      t.string :address

      t.timestamps
    end
  end
end
