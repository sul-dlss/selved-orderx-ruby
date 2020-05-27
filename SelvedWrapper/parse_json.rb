# frozen_string_literal: true

require 'json'

# class to parse the selved json
class ParseJson
  def initialize(json)
    @json = json
  end

  def main
    hash = JSON.parse(@json)
    print(hash)
  end

  def print(hash)
    result = []
    hash.each do |key, value|
      result << "#{key}: "
      value.each do |data|
        result << data['D']
      end
    end

    result.join(', ').gsub(', &#124;a', '')
  end
end
