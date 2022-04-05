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
    lines = File.readlines(file, chomp: true)
    lines.each_with_index do |line, index|
      line_array = line.split('|')
      # Example of output line of selorder from expenditure report
      # For Expenditures, Hash key will be a concatenation of the orderline key and the fund id
      # (e.g. 5532267_1065031-105-KBADW_0)
      # 4576261|20200824|4576261|EAPPROVAL|-5492251|13677727|1||5532267|1065031-105-KBADW|1|20200824|
      # For Encumbrances it is the fiscal cycle + order key (e.g 2021_4556074_0).
      # 4556074|20200811|1|20190904|$0.00|2021|SUL|503724F20|2021|4556074|
      # Add a line index value to ensure absolute uniqueness..
      begin
        key = "#{line_array.slice(8..9).join('_')}_#{index}"
      rescue NoMethodError # when trying to do a join on a non-existing slice range
        next
      end
      data = line_array.join('|')
      @hash[key] = data.chomp
    end
  end

  def update_hash(file)
    lines = File.readlines(file)
    @hash.each do |key, value|
      hash_order_key = value.split('|')[0]
      lines.each do |line|
        line_array = line.chomp.split('|')
        line_array[0] == hash_order_key && (@hash[key] << "|#{line_array.slice(-1)}") && break
      end
    end
  end

  def pipe_hash
    @hash.each do |_, value|
      pipe_vals = value.split('|')
      # Test if the last pipe field is parsable
      begin
        last_pipe = parse_json(pipe_vals[-1])
      rescue TypeError, JSON::ParserError, NoMethodError
        last_pipe = pipe_vals[-1]
      end
      data = pipe_vals.pop && pipe_vals.push(last_pipe) && pipe_vals.join('|')
      # data includes trailing pipe: data|
      print "#{data}|\n"
    end
  end

  def parse_json(json)
    parser = ParseJson.new(json)
    parser.main
  end
end
