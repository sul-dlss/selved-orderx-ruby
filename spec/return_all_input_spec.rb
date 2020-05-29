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
        expect(output.size).to eq 11
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

    describe 'stdout' do
      before do
        result.update_hash('spec/fixtures/order_keys.txt')
      end

      it 'should be a pipe-delimited string' do
        printed = capture_stdout do
          result.pipe_hash('spec/fixtures/selved_data.txt')
        end

        expect(printed.include?('4345863|BIGDEAL: Test Bigdeal|')).to be_truthy
      end
    end
  end

  context 'when there are several fields of order data in the order_keys file' do
    describe 'pipe_hash adds the matching selved data using the order key' do
      before do
        result.update_hash('spec/fixtures/selorder_data.txt')
      end

      it 'keeps the same number of entries' do
        output = result.pipe_hash('spec/fixtures/selved_selorder_data.txt')
        expect(output.size).to eq 10
      end

      it 'populates the matching selved data' do
        output = result.pipe_hash('spec/fixtures/selved_data.txt')
        expect(output['4015377'].length).to be > 10
      end

      it 'parses the selved json' do
        output = result.pipe_hash('spec/fixtures/selved_selorder_data.txt')
        expect(output['4109500']).to eq '|20171121|4109500|APPROVAL|{'\
                                                '"BIGDEAL":[{"A":4,"D":"&#124;aThis is a big deal","I":""}],'\
                                                '"MULTIYEAR":[{"A":5,"D":"&#124;a2018 to present","I":""}],'\
                                                '"DATA":[{"A":6,"D":"&#124;aThis is data","I":""}],'\
                                                '"STREAMING":[{"A":7,"D":"&#124;aThis is streaming","I":""}]}'
      end
    end
  end

  describe 'stdout' do
    before do
      result.update_hash('spec/fixtures/selorder_data.txt')
    end

    it 'should be a pipe-delimited string' do
      printed = capture_stdout do
        result.pipe_hash('spec/fixtures/selved_selorder_data.txt')
      end

      expect(printed.include?('4345863|19971222|4345863|SUBSCRIPT|BIGDEAL: Test Bigdeal|')).to be_truthy
    end
  end
end

def capture_stdout(&blk)
  old = $stdout
  $stdout = fake = StringIO.new
  blk.call
  fake.string
ensure
  $stdout = old
end
