module Common.World where

import qualified Data.Word

type Word = Data.Word.Word64

data WorldDim = WorldDim Word
    deriving (Show, Eq)

instance Num WorldDim where
    (+) (WorldDim x) (WorldDim y) = WorldDim (x + y)
    (-) (WorldDim x) (WorldDim y) = WorldDim (x - y)
    (*) (WorldDim x) (WorldDim y) = WorldDim (x * y)
    negate (WorldDim x) = WorldDim x
    abs (WorldDim x) = WorldDim (abs x)
    signum (WorldDim x) = WorldDim (signum x)
    fromInteger x = WorldDim (fromInteger x)

class Scalable a where
    toWorldDim :: a -> WorldDim
    fromWorldDim :: WorldDim -> a

-- TODO:
-- Check whether toString -> substring -> toInt is faster or not of power calculus.
-- Check whether 'digits' module is faster or not.
quadrantScale, clusterScale, areaScale, positionScale :: Word
quadrantScale = 10^18
clusterScale = 10^15
areaScale = 10^12
positionScale = 10^9


data Quadrant = Quadrant Word
    deriving (Show, Eq)
data Cluster = Cluster Word
    deriving (Show, Eq)
data Area = Area Word
    deriving (Show, Eq)
data Position = Position Word
    deriving (Show, Eq)
data WorldPos = WorldPos Quadrant Cluster Area Position
    deriving (Show, Eq)

instance Scalable Quadrant where
    toWorldDim (Quadrant x) = WorldDim (x * clusterScale)
    fromWorldDim (WorldDim x) = Quadrant (x `div` clusterScale)
    
instance Scalable Cluster where
    toWorldDim (Cluster x) = WorldDim (x * areaScale)
    fromWorldDim wd@(WorldDim x) = Cluster ((x `mod` clusterScale) `div` areaScale)
    
instance Scalable Area where
    toWorldDim (Area x) = WorldDim (x * positionScale)
    fromWorldDim wd@(WorldDim x) = Area ((x `mod` areaScale) `div` positionScale)
    
instance Scalable Position where
    toWorldDim (Position x) = WorldDim x
    fromWorldDim wd@(WorldDim x) = Position (x `mod` positionScale)
        
instance Scalable WorldPos where
    toWorldDim (WorldPos q c a p) = toWorldDim q + toWorldDim c + toWorldDim a + toWorldDim p
    fromWorldDim wd@(WorldDim x) = let
        qd = fromWorldDim wd
        cl = fromWorldDim wd
        ar = fromWorldDim wd
        pos = fromWorldDim wd
        in WorldPos qd cl ar pos 

 
 
 
 