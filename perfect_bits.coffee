BigNumber = require 'bignumber.js'

# Sum an array of items, given a iteratee function wich is invoked for each element in the array.
# Compare to https://lodash.com/docs#sumBy
# Would have used lodash here, except that I needed BigNumber
sum = (array, iteratee) ->
  array.reduce(
    ((total, value) -> total.plus(iteratee value)),
    new BigNumber 0
  )

# 5 --> '101'
numberAsBinaryString = (val) -> new BigNumber(val).toString(2)

# '101' --> 5
binaryStringAsNumber = (val) -> new BigNumber(val, 2)

# Grab the number of ones in the binary representation of a number
# i.e., 5 --> '101' --> 2
numOnes = (val) -> numberAsBinaryString(val).replace(/0/g, '').length

# Figure out how many binary digits a decimal number requires
# i.e., 5 --> '101' --> 3
binaryMagnitudeOf = (num) -> new BigNumber(numberAsBinaryString(num).length)

# Remove the most significant binary digit from a decimal number
# i.e., 13 --> '1101' --> '101' --> 5
# i.e., 5  --> '101'  --> '01'  --> 1
stripLargestBinaryMagnitude = (num) ->
  strippedNumber = numberAsBinaryString(num).substr(1)
  return new BigNumber(0) if strippedNumber.length is 0
  binaryStringAsNumber strippedNumber

# Compute a factorial, optionally with another factorial subtracted
# Needed BigNumber support, which is why I ended up writing this myself
# i.e., factorial(10) --> 362880
# i.e., factorial(10, 9) --> 720
factorial = (value, stoppingPoint = 1) ->
  return new BigNumber(1) if value.lessThanOrEqualTo(0)
  return value if value.lessThanOrEqualTo stoppingPoint
  value.times(factorial value.minus(1), stoppingPoint)

# Compute a combination (nCr)
# Needed BigNumber support, which is why I ended up writing this myself
# Compare to, for example, the js-combinatorics node module
# (https://github.com/dankogai/js-combinatorics#arithmetic-functions)
combination = (n, r) ->
  result = switch
    when n.lessThan(r) then new BigNumber(0)
    when r.equals(0) then new BigNumber(1)
    when r.isNegative() then new BigNumber(0)
    else factorial(n, n.minus(r).plus(1)).div(factorial r)
  result

# Determine the number of times that a specific number of '1' digits
# appear in binary representations of the range [0..max]
numberOfWaysToArrangeOnesInRange = (max, numberOfOnes) ->
  switch
    # base cases
    when max.lessThanOrEqualTo(0) then new BigNumber(0)
    when numberOfOnes.isNegative() then new BigNumber(0)
    when binaryMagnitudeOf(max).lessThan(numberOfOnes) then new BigNumber(0)

    # without this, we'd be calculating for the range [0...max] instead:
    when numberOfOnes.equals(numOnes max) then do ->
      numberOfWaysToArrangeOnesInRange(max.minus(1), numberOfOnes).plus(1)

    # recurse. see point (5) in readme for specifics here.
    else do ->
      combination(
        binaryMagnitudeOf(max).minus(1),
        numberOfOnes
      ).plus(
        numberOfWaysToArrangeOnesInRange(
          stripLargestBinaryMagnitude(max),
          numberOfOnes.minus(1)
        )
      )

# Since we're dealing with 64-bit integers, we only need perfect squares
# up to and including 64 (or 8^2)
perfectSquares = [1..8].map (val) -> new BigNumber(val).pow(2)

# Finally, here is our perfectBits function, which calculates number of
# of instances in the range from min to max in which the number of ones
# in the binary representation of that number is a perfect square.
# Expects that the numbers provided are 64-bit integers, or (since this
# is javascript, which only has a Number type that's a 64-bit double
# with a max value of (2^53)-1), a string representing that integer
module.exports = perfectBits = (min, max) ->
  [min, max] = [min, max].map (val) -> new BigNumber(val)
  sum perfectSquares, (perfectSquare) ->
    fullMax = numberOfWaysToArrangeOnesInRange(max, perfectSquare)
    fullMin = numberOfWaysToArrangeOnesInRange(min, perfectSquare)
    fullMax.minus(fullMin)

module.exports.factorial = factorial
