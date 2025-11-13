# frozen_string_literal: true

require 'axm'
require 'openssl'

RSpec.describe Axm::Client do
  let(:client_id) { 'SCHOOLAPI.EXAMPLEWXYZ5678' }
  let(:private_key) { OpenSSL::PKey::EC.generate('prime256v1').to_pem }
  let(:key_id) { '' }

  let(:client) { described_class.new(client_id:, key_id:, private_key:) }

  describe '#scope' do
    context 'when the client ID is for Apple Business Manager' do
      let(:client_id) { 'BUSINESSAPI.EXAMPLEABCD1234' }

      it { expect(client.scope).to eq('business') }
    end

    context 'when the client ID is for Apple School Manager' do
      let(:client_id) { 'SCHOOLAPI.EXAMPLEABCD1234' }

      it { expect(client.scope).to eq('school') }
    end

    context 'when the client ID has an unknown prefix' do
      let(:client_id) { 'MYAPI.EXAMPLEABCD1234' }

      it { expect { client.scope }.to raise_error(ArgumentError, 'Unknown client_id prefix: MYAPI') }
    end
  end
end
