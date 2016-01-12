BigNumber = require 'bignumber.js'
assert = require 'assert'
perfectBits = require './perfect_bits'

passCount = 0

perfectBitsShouldEqual = (min, max, expectedOutput) ->
  min = new BigNumber min
  max = new BigNumber max
  expectedOutput = new BigNumber expectedOutput
  output = perfectBits min, max
  assert.equal output.toString(), expectedOutput.toString(), """
    FAIL: perfectBits(#{min.toString()}, #{max.toString()})
      Expected #{expectedOutput.toString()}
           Got #{output.toString()}
  """
  ++passCount

perfectBitsShouldEqual '0', '1645098712823793798', '124716774454959560'
perfectBitsShouldEqual '0', '14889998042940624528', '1194719447656089277'
perfectBitsShouldEqual '1645098712823793798', '14889998042940624528', '1070002673201129717'
perfectBitsShouldEqual '510', '512', '2'
perfectBitsShouldEqual '39510914', '6341733670833843', '701295528477221'
perfectBitsShouldEqual '662109295137679', '913722178398903', '30016896275837'

console.log "OK. #{passCount} tests passed."
