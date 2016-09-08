{-# LANGUAGE BangPatterns #-}
module Bench.WordArray where

import Control.Monad.Primitive
import Data.Primitive.Array


type WordArray = Array Word

type MutableWordArray m = MutableArray (PrimState m) Word

{-# INLINE newWordArray #-}
newWordArray :: PrimMonad m => Int -> m (MutableWordArray m)
newWordArray !len = newArray len 0

{-# INLINE readWordArray #-}
readWordArray :: PrimMonad m => MutableWordArray m -> Int -> m Word
readWordArray !marr !i = readArray marr i

{-# INLINE unsafeFreezeWordArray #-}
unsafeFreezeWordArray :: PrimMonad m => MutableWordArray m -> m WordArray
unsafeFreezeWordArray !marr = unsafeFreezeArray marr

{-# INLINE indexWordArray #-}
indexWordArray :: WordArray -> Int -> Word
indexWordArray !arr !i = indexArray arr i

{-# INLINE indexWordArrayM #-}
indexWordArrayM :: Monad m => WordArray -> Int -> m Word
indexWordArrayM !arr !i = case indexArray arr i of x -> return x

{-# INLINE writeWordArray #-}
writeWordArray :: PrimMonad m => MutableWordArray m -> Int -> Word -> m ()
writeWordArray !marr !i !w = writeArray marr i w

{-# INLINE setWordArray #-}
setWordArray :: PrimMonad m => MutableWordArray m -> Int -> Int -> Word -> m ()
setWordArray !marr !offset !count !word =
    loop offset (offset + count)
  where
    loop !off !end
        | off < end = do
            writeWordArray marr off word
            loop (off + 1) end
        | otherwise = return ()

{-# INLINE copyWordArray #-}
copyWordArray :: PrimMonad m => MutableWordArray m -> Int -> WordArray -> Int -> Int -> m ()
copyWordArray !marr !doff !arr !soff !wrds =
    let loop !i
            | i < wrds =  do
                !x <- indexWordArrayM arr (soff + i)
                writeWordArray marr (doff + i) x
                loop (i + 1)
            | otherwise = return ()
    in loop 0
