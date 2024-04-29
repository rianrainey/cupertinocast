class Forecast < ApplicationRecord
  include AddressHelper
  validate :zip_code_must_be_valid?

  def outdated?
    last_search_date.blank? || last_search_date < 30.minutes.ago
  end

  def zip_code_must_be_valid?
    if parse_zip_code(zip_code).blank?
      errors.add(:zip_code, 'is invalid')
    end
  end
end
