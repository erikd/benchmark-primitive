{-# LANGUAGE BangPatterns #-}
module Bench.WordArrayB where

import Control.Monad.Primitive
import Data.Primitive


newtype WordArray = WA ByteArray

newtype MutableWordArray m = MWA (MutableByteArray (PrimState m))

{-# INLINE newWordArray #-}
newWordArray :: PrimMonad m => Int -> m (MutableWordArray m)
newWordArray !len = do
    !marr <- newByteArray (len * sizeOf (0 :: Word))
    return $ MWA marr

{-# INLINE readWordArray #-}
readWordArray :: PrimMonad m => MutableWordArray m -> Int -> m Word
readWordArray (MWA !marr) = readByteArray marr

{-# INLINE unsafeFreezeWordArray #-}
unsafeFreezeWordArray :: PrimMonad m => MutableWordArray m -> m WordArray
unsafeFreezeWordArray (MWA !marr) = do
    !arr <- unsafeFreezeByteArray marr
    return (WA arr)

{-# INLINE indexWordArray #-}
indexWordArray :: WordArray -> Int -> Word
indexWordArray (WA !arr) = indexByteArray arr

{-# INLINE indexWordArrayM #-}
indexWordArrayM :: Monad m => WordArray -> Int -> m Word
indexWordArrayM (WA !arr) !i = case indexByteArray arr i of x -> return x

{-# INLINE writeWordArray #-}
writeWordArray :: PrimMonad m => MutableWordArray m -> Int -> Word -> m ()
writeWordArray (MWA !marr) = writeByteArray marr

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
