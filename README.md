# benchmark-primitive

A quick benchmark of two types in Haskell's `primitve` library.

Have two implemenations of a WordArray. Once builds on top of `ByteArray` and
the other uses `Array Word`. I expected the performance of these two
implementations to be identical, but for some reason the `Array Word` one
seems to be roughly 4 times slower than the `ByteArray` version.

I am open to the possibilty of this being a bug in my code. If its not, then
`Data.Primitve` needs fixing.

To build and run the benchmark:
```
cabal sandbox init
cabal install --dependencies-only
cabal build
dist/build/benchmark-primitive/benchmark-primitive
```

Running this test with ghc-8.0.1 on a recent Macbook Pro running Debian
Linux, I'm getting results like this:
```
benchmarking copyWordArray 1000/Data.Primitive,Array Word
time                 3.438 μs   (3.432 μs .. 3.444 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 3.437 μs   (3.434 μs .. 3.448 μs)
std dev              20.61 ns   (10.54 ns .. 40.85 ns)

benchmarking copyWordArray 1000/Data.Primitive.ByteArray
time                 612.2 ns   (611.3 ns .. 613.2 ns)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 611.9 ns   (611.2 ns .. 613.1 ns)
std dev              2.910 ns   (1.635 ns .. 4.961 ns)

benchmarking copyWordArray 10000/Data.Primitive,Array Word
time                 28.71 μs   (28.63 μs .. 28.79 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 28.67 μs   (28.63 μs .. 28.75 μs)
std dev              193.3 ns   (117.3 ns .. 346.1 ns)

benchmarking copyWordArray 10000/Data.Primitive.ByteArray
time                 6.001 μs   (5.992 μs .. 6.012 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 6.000 μs   (5.994 μs .. 6.014 μs)
std dev              30.21 ns   (18.17 ns .. 54.13 ns)

benchmarking copyWordArray 100000/Data.Primitive,Array Word
time                 291.5 μs   (291.0 μs .. 292.2 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 291.8 μs   (291.3 μs .. 292.8 μs)
std dev              2.070 μs   (1.146 μs .. 3.810 μs)

benchmarking copyWordArray 100000/Data.Primitive.ByteArray
time                 60.88 μs   (60.86 μs .. 60.90 μs)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 60.93 μs   (60.91 μs .. 61.00 μs)
std dev              110.9 ns   (42.01 ns .. 212.5 ns)

```




