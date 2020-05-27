#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'SelvedWrapper/return_all_input'

result = ReturnAllInput.new
result.update_hash(ARGV[0])
result.pipe_hash(ARGV[1])
