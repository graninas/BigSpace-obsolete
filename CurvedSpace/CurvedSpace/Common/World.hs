module Common.World where

import Common.Types

data Axis = XAxis | YAxis | ZAxis | AnyAxis | AnyXYAxis
    deriving (Show, Eq)
data WorldAxis = WorldAxis Axis Word
    deriving (Show, Eq)

instance Num WorldAxis where
    (+) (WorldAxis a x) (WorldAxis b y) | a == b = WorldAxis a (x + y)
                                        | otherwise = error "Axes should be same."
    (-) (WorldAxis a x) (WorldAxis b y) | a == b = WorldAxis a (x - y)
                                        | otherwise = error "Axes should be same."
    (*) (WorldAxis a x) (WorldAxis b y) | a == b = WorldAxis a (x * y)
                                        | otherwise = error "Axes should be same."
    negate (WorldAxis a x) = WorldAxis a x
    abs (WorldAxis a x) = WorldAxis a (abs x)
    signum (WorldAxis a x) = WorldAxis a (signum x)
    fromInteger x = WorldAxis AnyAxis (fromInteger x)

toXWorldAxis, toYWorldAxis, toZWorldAxis :: WorldAxis -> WorldAxis
toXWorldAxis (WorldAxis _ x) = WorldAxis XAxis x
toYWorldAxis (WorldAxis _ x) = WorldAxis YAxis x
toZWorldAxis (WorldAxis _ x) = WorldAxis ZAxis x

class Scalable a where
    toWorldAxis :: a -> WorldAxis
    fromWorldAxis :: WorldAxis -> a
-- TODO:
-- Check whether toString -> substring -> toInt is faster or not of power calculus.
-- Check whether 'digits' module is faster or not.
quadrantScale, clusterScale, areaScale, positionScale :: Word
quadrantScale = 10^19
clusterScale = 10^18
areaScale = 10^15
positionScale = 10^12


data Quadrant = Quadrant Word
    deriving (Show, Eq)
data Cluster = Cluster Word
    deriving (Show, Eq)
data Area = Area Word
    deriving (Show, Eq)
data Position = Position Word
    deriving (Show, Eq)
data Layer = Layer Word
    deriving (Show, Eq)
data GalaxyGrid = GalaxyXGrid Quadrant Cluster Area Position
                | GalaxyYGrid Quadrant Cluster Area Position
                | GalaxyLayer Quadrant Cluster Area Position
    deriving (Show, Eq)

instance Scalable Quadrant where
    toWorldAxis (Quadrant x) = WorldAxis AnyXYAxis (x * clusterScale)
    fromWorldAxis (WorldAxis _ x) = Quadrant (x `div` clusterScale)
    
instance Scalable Cluster where
    toWorldAxis (Cluster x) = WorldAxis AnyXYAxis (x * areaScale)
    fromWorldAxis wd@(WorldAxis _ x) = Cluster ((x `mod` clusterScale) `div` areaScale)
    
instance Scalable Area where
    toWorldAxis (Area x) = WorldAxis AnyXYAxis (x * positionScale)
    fromWorldAxis wd@(WorldAxis _ x) = Area ((x `mod` areaScale) `div` positionScale)
    
instance Scalable Position where
    toWorldAxis (Position x) = WorldAxis AnyXYAxis x
    fromWorldAxis wd@(WorldAxis _ x) = Position (x `mod` positionScale)
        
instance Scalable GalaxyGrid where
    toWorldAxis (GalaxyXGrid q c a p) = toXWorldAxis (toWorldAxis q + toWorldAxis c + toWorldAxis a + toWorldAxis p)
    toWorldAxis (GalaxyYGrid q c a p) = toYWorldAxis (toWorldAxis q + toWorldAxis c + toWorldAxis a + toWorldAxis p)
    toWorldAxis (GalaxyLayer q c a p) = toZWorldAxis (toWorldAxis q + toWorldAxis c + toWorldAxis a + toWorldAxis p)
    fromWorldAxis wd@(WorldAxis a x) = let
        qd = fromWorldAxis wd
        cl = fromWorldAxis wd
        ar = fromWorldAxis wd
        pos = fromWorldAxis wd
        in case a of
            XAxis -> GalaxyXGrid qd cl ar pos
            YAxis -> GalaxyYGrid qd cl ar pos
            ZAxis -> GalaxyLayer qd cl ar pos
            otherwise -> error ("WorldAxis Axis should be concrete, not " ++ show a ++ ".")

 
data WorldDim = WorldDim WorldAxis WorldAxis WorldAxis 
    deriving (Show, Eq)
 

homeXAxis, homeYAxis, homeZAxis :: WorldAxis
homeXAxis = toXWorldAxis . fromInteger $ 255548795444
homeYAxis = toYWorldAxis . fromInteger $ 387957987
homeZAxis = toZWorldAxis . fromInteger $ 123893249014
 
homePoint :: WorldDim
homePoint = WorldDim homeXAxis homeYAxis homeZAxis
    
    