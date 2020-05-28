# frozen_string_literal: true

require 'spec_helper'
require_relative '../SelvedWrapper/return_all_input'

RSpec.describe ReturnAllInput do
  let(:result) { described_class.new }

  describe 'update_hash' do
    it 'populates the hash with the initial set of order keys' do
      keys = result.update_hash('spec/fixtures/order_keys.txt')
      expect(keys.size).to eq 11
    end
  end

  context 'when there is only an order key as the input' do
    describe 'pipe_hash adds the matching selved data using the order key' do
      before do
        result.update_hash('spec/fixtures/order_keys.txt')
      end

      it 'keeps the same number of entries' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output.size).to eq 14
      end

      it 'populates the matching selved data' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output['4109500'].length).to be > 10
      end

      it 'parses the selved json' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output['4345863']).to eq '|{"BIGDEAL":[{"A":5,"D":"&#124;aTest Bigdeal","I":""}]}'
      end
    end
  end

  context 'when there are several fields of order data in the order_keys file' do
    describe 'pipe_hash adds the matching selved data using the order key' do
      before do
        result.update_hash('spec/fixtures/selorder_data.txt')
      end

      it 'keeps the same number of entries' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output.size).to eq 11
      end

      it 'populates the matching selved data' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output['4015377'].length).to be > 10
      end

      it 'parses the selved json' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output['4015377']).to eq '|20170628|4015377|APPROVAL|{"STREAMING":[{"A":5,"D":"&#124;aHosted by a test service","I":""}]}'
      end
    end
  end
end
