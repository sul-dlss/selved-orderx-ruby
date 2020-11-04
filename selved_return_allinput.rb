#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'SelvedWrapper/return_all_input'

result = ReturnAllInput.new
result.populate_hash(ARGV[0])
result.update_hash(ARGV[1])
result.pipe_hash
