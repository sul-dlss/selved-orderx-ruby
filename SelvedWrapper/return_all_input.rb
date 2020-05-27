# frozen_string_literal:true

require_relative 'parse_json'

# To be used in place of selved, so that input records that do not have any ved data get returned anyway
# i.e., don't lose input lines
class ReturnAllInput
  def initialize
    @hash = {}
  end

  def update_hash(file)
    lines = IO.readlines(file, chomp: true)
    lines.each do |line|
      line_array = line.split('|')
      key = line_array[0]
      data = line_array[1, line_array.length].join('|')
      @hash[key] = data
    end
  end

  def pipe_hash(file)
    update_hash(file)
    @hash.each do |key, value|
      value.empty? ? parsed_val = '' : parsed_val = parse_json(value)
      print "#{key}|#{parsed_val}|\n"
    end
  end

  def parse_json(json)
    parser = ParseJson.new(json)
    parser.main
  end
end
