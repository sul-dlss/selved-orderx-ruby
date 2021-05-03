# frozen_string_literal: true

require 'spec_helper'
require_relative '../SelvedWrapper/return_all_input'

RSpec.describe ReturnAllInput do
  let(:result) { described_class.new }

  describe 'update_hash' do
    it 'populates the hash with the initial set of order keys' do
      keys = result.populate_hash('spec/fixtures/expend_report_selorder_data.txt')
      expect(keys.size).to eq 306
    end
  end

  describe 'update_hash adds the matching selved data using the orderline pipe field + fund id as the hash key' do
    before do
      result.populate_hash('spec/fixtures/expend_report_selorder_data.txt')
      result.update_hash('spec/fixtures/selved_data.txt')
    end

    it 'keeps the same number of entries' do
      expect(result.hash.size).to eq 306
    end

    it 'populates the matching selved data' do
      puts result.hash
      expect(result.hash['5560684_1065032-101-NAAUS_234'].length).to be > 12
    end

    it 'parses the selved json' do
      result.pipe_hash
      expect(result.hash['5560684_1065032-101-NAAUS_234'])
        .to eq '4588388|20201026|4588388|VISUAL|-5510489|'\
                        '13728055|1|BLS|5560684|1065032-101-NAAUS|1|20201026|'\
                        '{"STREAMING":[{"A":8,"D":"&#124;aHosted by New Day Films","I":"","X":4}]}'
    end
  end

  describe 'stdout' do
    before do
      result.populate_hash('spec/fixtures/expend_report_selorder_data.txt')
      result.update_hash('spec/fixtures/selved_data.txt')
    end

    it 'should be a pipe-delimited string' do
      printed = capture_stdout do
        result.pipe_hash
      end

      expect(printed.include?('1065032-101-NAAUS|1|20201026|STREAMING: Hosted by New Day Films|')).to be_truthy
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
