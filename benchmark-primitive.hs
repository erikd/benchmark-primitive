import qualified Bench.WordArray as A
import qualified Bench.WordArrayB as B

import qualified Criterion.Main as C

main :: IO ()
main = do
    let maxlen = 100000

    asrc <- A.unsafeFreezeWordArray =<< A.newWordArray maxlen
    adest <- A.newWordArray maxlen

    bsrc <- B.unsafeFreezeWordArray =<< B.newWordArray maxlen
    bdest <- B.newWordArray maxlen

    C.defaultMain
        [ C.bgroup "copyWordArray 1000"
            [ C.bench "Data.Primitive,Array Word"   $ C.whnfIO $ benchA 1000 asrc adest
            , C.bench "Data.Primitive.ByteArray"    $ C.whnfIO $ benchB 1000 bsrc bdest
            ]
        , C.bgroup "copyWordArray 10000"
            [ C.bench "Data.Primitive,Array Word"   $ C.whnfIO $ benchA 10000 asrc adest
            , C.bench "Data.Primitive.ByteArray"    $ C.whnfIO $ benchB 10000 bsrc bdest
            ]
        , C.bgroup "copyWordArray 100000"
            [ C.bench "Data.Primitive,Array Word"   $ C.whnfIO $ benchA 100000 asrc adest
            , C.bench "Data.Primitive.ByteArray"    $ C.whnfIO $ benchB 100000 bsrc bdest
            ]
        ]

benchA :: Int -> A.WordArray -> A.MutableWordArray IO -> IO ()
benchA len src dest = A.copyWordArray dest 0 src 0 len


benchB :: Int -> B.WordArray -> B.MutableWordArray IO -> IO ()
benchB len src dest = B.copyWordArray dest 0 src 0 len
