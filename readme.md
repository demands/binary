Insights:

1. Since we are working with 64-bit integers, the maximum number of ones is 64.
   This means that there are no numbers in our range [0...2^64] whose ones add
   up to a perfect square > 64. So our list of possible perfect squares is
   actually quite small.

2. Figuring out how many numbers in the range [0...2^n] have m ones is actually
   a well-understood combinatorics problem: nCm or combination(n, m).

3. To calculate how many numbers in the range [0...n] have m ones, you can
   factor the number out into k powers of 2, and for each factor f[i] for i in
   [0...k], calculate the amount of numbers in the range [0...f[i]] that have
   m-i ones using insight 2. This is kinda complicated written down, but some
   examples might help:

     The number of arrangements of 4 ones in [0...100000100] =
         [000000000...100000000] = combination(8, 4) = 70
       + [100000000...100000100] = combination(2, 3) = 0
       = 70

     The number of arrangements of 4 ones in [0...111111111] =
         [000000000...100000000] = combination(8, 4) = 70
       + [100000000...110000000] = combination(7, 3) = 35
       + [110000000...111000000] = combination(6, 2) = 15
       + [111000000...111100000] = combination(5, 1) = 5
       + [111100000...111110000] = combination(4, 0) = 1
       + [111110000...111111000] = 0
       + [111111000...111111100] = 0
       + [111111100...111111110] = 0
       + [111111110...111111111] = 0
       = 125

     The number of arrangements of 9 ones in [0...111111110] =
         [000000000...100000000] = combination(8, 9) = 0
       + [100000000...110000000] = combination(7, 8) = 0
       + [110000000...111000000] = combination(6, 7) = 0
       + [111000000...111100000] = combination(5, 6) = 0
       + [111100000...111110000] = combination(4, 5) = 0
       + [111110000...111111000] = combination(3, 4) = 0
       + [111111000...111111100] = combination(2, 3) = 0
       + [111111100...111111110] = combination(1, 2) = 0
       = 125

     The number of arrangements of 1 ones in [0...111111111] =
         [000000000...100000000] = combination(8, 1) = 8
       + [100000000...110000000] = combination(7, 0) = 1
       + [110000000...111000000] = 0
       + [111000000...111100000] = 0
       + [111100000...111110000] = 0
       + [111110000...111111000] = 0
       + [111111000...111111100] = 0
       + [111111100...111111110] = 0
       + [111111110...111111111] = 0
       = 125

