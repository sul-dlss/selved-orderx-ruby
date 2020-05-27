# frozen_string_literal: true

require 'spec_helper'
require_relative '../SelvedWrapper/parse_json'

RSpec.describe ParseJson do
  json = File.read('spec/fixtures/selved.json')
  let(:parser) { described_class.new(json) }

  let(:result) do
    'BIGDEAL: This is a big deal, MULTIYEAR: 2018 to present, DATA: This is data, STREAMING: This is streaming'
  end

  it 'parses the json' do
    expect(parser.main).to eq result
  end
end
