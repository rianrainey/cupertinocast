class Forecast < ApplicationRecord
  def retrieve_from_api?
    last_search_date.blank? || last_search_date < 30.minutes.ago
  end
end
