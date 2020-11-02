# frozen_string_literal:true

require_relative 'parse_json'

# To be used in place of selved, so that input records that do not have any ved data get returned anyway
# i.e., don't lose input lines
class ReturnAllInput
  attr_accessor :hash

  def initialize
    @hash = {}
  end

  def populate_hash(file)
    lines = IO.readlines(file, chomp: true)
    lines.each do |line|
      line_array = line.split('|')
      key = line_array.slice(8..9).join('_')
      data = line_array.join('|')
      @hash[key] = data.chomp
    end
  end

  def update_hash(file)
    lines = IO.readlines(file, chomp: true)
    lines.each do |line|
      line_array = line.split('|')
      @hash.each do |key, value|
        hash_order_key = value.split('|')[0]
        hash_order_key == line_array[0] && @hash[key] << "|#{line_array.slice(-1)}"
      end
    end
  end

  def pipe_hash
    @hash.each do |key, value|
      pipe_vals = value.split('|')
      # Test if the last pipe field is parsable
      begin
        last_pipe = parse_json(pipe_vals[-1])
      rescue TypeError, JSON::ParserError, NoMethodError
        last_pipe = pipe_vals[-1]
      end
      data = pipe_vals.pop && pipe_vals.push(last_pipe) && pipe_vals.join('|')
      # data includes leading pipe: |data
      print "#{data}|\n"
    end
  end

  def parse_json(json)
    parser = ParseJson.new(json)
    parser.main
  end
end
