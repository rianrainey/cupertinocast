require "rails_helper"

RSpec.describe AddressHelper do
  include AddressHelper

  describe '#parse_zip_code' do
    context 'when the address is empty' do
      let(:address) { '' }

      it 'returns nil' do
        expect(parse_zip_code(address)).to be_nil
      end
    end

    context 'when the address is valid' do
      let(:address) { '12345 Main St 94101' }

      it 'returns the zip code' do
        address = '12345 Main St 94101'
        expect(parse_zip_code(address)).to eq('94101')
      end
    end

    context 'when the address contains only a zip code' do
      let(:address) { '94101' }

      it 'returns the zip code' do
        expect(parse_zip_code(address)).to eq('94101')
      end
    end

    context 'when the address contains zip code greater than a 5 digit number' do
      let(:address) { '12345 Main St 941011' }

      it 'returns nil' do
        expect(parse_zip_code(address)).to be_nil
      end
    end

    context 'when the address contains zip code less than a 5 digit number' do
      let(:address) { '9410' }

      it 'returns nil' do
        expect(parse_zip_code(address)).to be_nil
      end
    end
  end
end

