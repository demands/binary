BigNumber = require 'bignumber.js'

sum = (array, reducer) ->
  array.reduce(
    ((total, value) -> total.plus(reducer value)),
    new BigNumber 0
  ).toNumber()

num_ones = (val) -> number_as_binary_string(val).replace(/0/g, '').length
perfect_squares = [1..8].map (val) -> new BigNumber(val).pow(2)

number_as_binary_string = (val) -> new BigNumber(val).toString(2)
binary_string_as_number = (val) -> new BigNumber(val, 2)

binary_magnitude_of = (num) -> new BigNumber(number_as_binary_string(num).length)

strip_largest_binary_magnitude = (num) ->
  stripped_number = number_as_binary_string(num).substr(1)
  return new BigNumber(0) if stripped_number.length is 0
  binary_string_as_number stripped_number

factorial = (value, stopping_point = 1) ->
  return value if value.lessThanOrEqualTo(stopping_point)
  value.times(factorial value.minus(1), stopping_point)

combination = (n, r) ->
  result = switch
    when r.equals(0) then new BigNumber(1)
    when n.lessThan(4) then new BigNumber(0)
    when r.isNegative() then new BigNumber(0)
    else factorial(n, n.minus(r).plus(1)).div(factorial r)
  console.log "C(#{n.toString()}, #{r.toString()}) => #{result.toString()}"
  result

number_of_ways_to_arrange_ones_in_range = (max, number_of_ones) ->
  return new BigNumber(0) if max.lessThanOrEqualTo(0) or number_of_ones.isNegative()
  return new BigNumber(0) if binary_magnitude_of(max).lessThanOrEqualTo(number_of_ones)
  combination(
    binary_magnitude_of(max).minus(1),
    number_of_ones
  ).plus(
    number_of_ways_to_arrange_ones_in_range(
      strip_largest_binary_magnitude(max),
      number_of_ones.minus(1)
    )
  ).plus(
    if number_of_ones.equals(num_ones(max)) then 1 else 0
  )

perfect_bits = (min, max) ->
  [min, max] = [min, max].map (val) -> new BigNumber(val)
  sum perfect_squares, (perfect_square) ->
    full_max = number_of_ways_to_arrange_ones_in_range(max, perfect_square)
    full_min = number_of_ways_to_arrange_ones_in_range(min, perfect_square)
    console.log {
      perfect_square: perfect_square.valueOf(),
      full_max: full_max.valueOf(),
      full_min: full_min.valueOf()
    }
    full_max.minus(full_min)

console.log perfect_bits('1645098712823793798', '14889998042940624528').toString()
console.log "1070002673201129717"
# num_ones = (val) -> number_as_binary_string(val).replace(/0/g, '').length

# naiive_solution = (min, max) ->
#   sum perfect_squares, (number) -> naiive_part_solution(min, max, number)

# naiive_part_solution = (min, max, number) ->
#   result = [min..max].filter((v) -> number.eq(num_ones(v))).map(number_as_binary_string).length
#   console.log {number: number.toString(), result}
#   result

# console.log number_as_binary_string(512)
# console.log perfect_bits(0, 512).toString()
# console.log naiive_solution(0, 512).toString()

