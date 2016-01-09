BigNumber = require 'bignumber.js'
combinatorics = require 'js-combinatorics'
_ = require 'lodash'

# TODO remove either this or lodash
sum = (array, reducer) ->
  array.reduce(
    ((total, value) -> total.plus(new BigNumber(reducer value))),
    new BigNumber 0
  ).toNumber()

perfect_squares = [1..8].map (val) -> val*val
console.log {perfect_squares}

number_as_binary_string = (val) -> val.toString(2)
binary_string_as_number = (val) -> parseInt(val, 2)

as_64_bit_binary = (val) ->
  binary = number_as_binary_string val
  throw new Error("Integer is more than 64 bits") if binary.length > 64
  num_zeroes = 64 - binary.length
  [0...num_zeroes].map(-> 0).join('') + binary

num_ones = (val) -> number_as_binary_string(val).replace(/0/g, '').length

binary_magnitude_of = (num) -> number_as_binary_string(num).length

strip_largest_binary_magnitude = (num) ->
  binary_string_as_number(number_as_binary_string(num).substr(1))

# Pretty much just calling out to the library, but adding some extra data validation
# TODO either fix the library or use something else?
combination = (factor, number_of_ones) ->
  return 0 if factor < number_of_ones
  return 0 if number_of_ones < 0
  out = combinatorics.C factor, number_of_ones
  console.log "combination(#{factor}, #{number_of_ones}) = #{out}"
  out

number_of_ways_to_arrange_ones_in_range = (max, number_of_ones) ->
  return 0 if max <= 0 or number_of_ones < 0
  return 0 if binary_magnitude_of(max) <= number_of_ones
  combination(
    binary_magnitude_of(max) - 1,
    number_of_ones
  ) + number_of_ways_to_arrange_ones_in_range(
    strip_largest_binary_magnitude(max),
    number_of_ones - 1
  )

perfect_bits = (min, max) ->
  _.sum perfect_squares, (perfect_square) ->
    full_max = number_of_ways_to_arrange_ones_in_range(max, perfect_square)
    full_min = number_of_ways_to_arrange_ones_in_range(min, perfect_square)
    console.log {perfect_square, full_max, full_min}
    full_max - full_min

naiive_solution = (min, max, vals = perfect_squares) ->
  [min...max].filter((v) -> num_ones(v) in vals).map(number_as_binary_string).length

assert = require 'assert'
#assert.equal perfect_bits(0, 511), naiive_solution(0, 511)
console.log perfect_bits(1645098712823793798, 14889998042940624528)
