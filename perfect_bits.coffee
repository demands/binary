BigNumber = require 'bignumber.js'

sum = (array, reducer) ->
  array.reduce(
    ((total, value) -> total.plus(reducer value)),
    new BigNumber 0
  )

numberAsBinaryString = (val) -> new BigNumber(val).toString(2)

binaryStringAsNumber = (val) -> new BigNumber(val, 2)

numOnes = (val) -> numberAsBinaryString(val).replace(/0/g, '').length

binaryMagnitudeOf = (num) -> new BigNumber(numberAsBinaryString(num).length)

stripLargestBinaryMagnitude = (num) ->
  strippedNumber = numberAsBinaryString(num).substr(1)
  return new BigNumber(0) if strippedNumber.length is 0
  binaryStringAsNumber strippedNumber

factorial = (value, stoppingPoint = 1) ->
  return new BigNumber(1) if value.lessThanOrEqualTo(0)
  return value if value.lessThanOrEqualTo stoppingPoint
  value.times(factorial value.minus(1), stoppingPoint)

combination = (n, r) ->
  result = switch
    when n.lessThan(r) then new BigNumber(0)
    when r.equals(0) then new BigNumber(1)
    when r.isNegative() then new BigNumber(0)
    else factorial(n, n.minus(r).plus(1)).div(factorial r)
  result

numberOfWaysToArrangeOnesInRange = (max, numberOfOnes) ->
  switch
    when max.lessThanOrEqualTo(0) then new BigNumber(0)
    when numberOfOnes.isNegative() then new BigNumber(0)
    when binaryMagnitudeOf(max).lessThan(numberOfOnes) then new BigNumber(0)
    when numberOfOnes.equals(numOnes max) then do ->
      numberOfWaysToArrangeOnesInRange(max.minus(1), numberOfOnes).plus(1)
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

perfectSquares = [1..8].map (val) -> new BigNumber(val).pow(2)
module.exports = perfectBits = (min, max) ->
  [min, max] = [min, max].map (val) -> new BigNumber(val)
  sum perfectSquares, (perfectSquare) ->
    fullMax = numberOfWaysToArrangeOnesInRange(max, perfectSquare)
    fullMin = numberOfWaysToArrangeOnesInRange(min, perfectSquare)
    fullMax.minus(fullMin)
