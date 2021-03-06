{-# LANGUAGE ScopedTypeVariables #-}
-- |Utilities for filling 'BufferObject's.
module Graphics.GLUtil.BufferObjects where
import Graphics.Rendering.OpenGL
import Foreign.ForeignPtr
import Foreign.Ptr
import Foreign.Storable
import Data.Array.Storable
import qualified Data.Vector.Storable as V
import Data.ByteString (ByteString, useAsCStringLen)

-- |Allocate and fill a 'BufferObject' from a list of 'Storable's.
makeBuffer :: Storable a => BufferTarget -> [a] -> IO BufferObject
makeBuffer target elems = makeBufferLen target (length elems) elems

-- |Allocate and fill a 'BufferObject' from a list of 'Storable's
-- whose length is explicitly given. This is useful when the list is
-- of known length, as it avoids a traversal to find the length.
makeBufferLen :: Storable a => BufferTarget -> Int -> [a] -> IO BufferObject
makeBufferLen target len elems = 
    do [buffer] <- genObjectNames 1
       bindBuffer target $= Just buffer
       let n = fromIntegral $ len * sizeOf (head elems)
       arr <- newListArray (0, len - 1) elems
       withStorableArray arr $ \ptr -> 
         bufferData target $= (n, ptr, StaticDraw)
       return buffer

-- |Allocate and fill a 'BufferObject' with the given number of bytes
-- from the supplied pointer.
fromPtr :: BufferTarget -> Int -> Ptr a -> IO BufferObject
fromPtr target numBytes ptr = 
  do [buffer] <- genObjectNames 1
     bindBuffer target $= Just buffer
     bufferData target $= (fromIntegral numBytes, ptr, StaticDraw)
     return buffer

-- |Fill a buffer with a 'ByteString'.
fromByteString :: BufferTarget -> ByteString -> IO BufferObject
fromByteString target b = useAsCStringLen b (uncurry . flip $ fromPtr target)

-- |Fill a buffer with data from a 'ForeignPtr'. The application
-- @fromForeignPtr target len fptr@ fills a @target@ 'BufferTarget'
-- with @len@ elements starting from @fptr@.
fromForeignPtr :: forall a. Storable a => 
                  BufferTarget -> Int -> ForeignPtr a -> IO BufferObject
fromForeignPtr target len fptr = withForeignPtr fptr $ fromPtr target numBytes
  where numBytes = sizeOf (undefined::a) * len

-- |Fill a buffer with data from a 'V.Vector'.
fromVector :: forall a. Storable a => 
              BufferTarget -> V.Vector a -> IO BufferObject
fromVector target v = V.unsafeWith v $ fromPtr target numBytes
  where numBytes = fromIntegral $ V.length v * sizeOf (undefined::a)

-- |Produce a 'Ptr' value to be used as an offset of the given number
-- of bytes.
offsetPtr :: Int -> Ptr a
offsetPtr = wordPtrToPtr . fromIntegral

-- |A zero-offset 'Ptr'.
offset0 :: Ptr a
offset0 = offsetPtr 0
