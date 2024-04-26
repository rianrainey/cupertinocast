module AddressHelper
  ZIP_CODE_REGEX = /(?:\D|^)(\d{5})(?=\D*$)/

  def parse_zip_code(address)
    address.scan(ZIP_CODE_REGEX).flatten.last
  end
end
