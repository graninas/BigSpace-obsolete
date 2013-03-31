module Common.World where

import Common.Types


data Quadrant = Quadrant Word
    deriving (Show, Eq)
data Axis = XAxis | YAxis | ZAxis | AnyAxis | AnyXYAxis
    deriving (Show, Eq)
data WorldAxis = WorldAxis Axis Quadrant Double
    deriving (Show, Eq)
    
    
zeroQuadrant = Quadrant 0

instance Num WorldAxis where
    (+) (WorldAxis a (Quadrant q1) x) (WorldAxis b (Quadrant q2) y) | a == b = WorldAxis a (Quadrant $ q1 + q2) (x + y)
                                              | otherwise = error "Axes should be same."
    (-) (WorldAxis a (Quadrant q1) x) (WorldAxis b (Quadrant q2) y) | a == b = WorldAxis a (Quadrant $ q1 + q2) (x - y)
                                              | otherwise = error "Axes should be same."
    (*) (WorldAxis a (Quadrant q1) x) (WorldAxis b (Quadrant q2) y) | a == b = WorldAxis a (Quadrant $ q1 + q2) (x * y)
                                              | otherwise = error "Axes should be same."
    negate (WorldAxis a q x) = WorldAxis a q x
    abs (WorldAxis a q x) = WorldAxis a q (abs x)
    signum (WorldAxis a q x) = WorldAxis a q (signum x)
    fromInteger x = WorldAxis AnyAxis zeroQuadrant (fromInteger x)

toXWorldAxis, toYWorldAxis, toZWorldAxis :: WorldAxis -> WorldAxis
toXWorldAxis (WorldAxis _ q x) = WorldAxis XAxis q x
toYWorldAxis (WorldAxis _ q x) = WorldAxis YAxis q x
toZWorldAxis (WorldAxis _ q x) = WorldAxis ZAxis q x

class Scalable a where
    fromWorldAxis :: WorldAxis -> a
-- TODO:
-- Check whether toString -> substring -> toInt is faster or not of power calculus.
-- Check whether 'digits' module is faster or not.
areaScaleModifier, clusterScaleModifier, clusterScale, areaScale, positionScale :: Word
areaScaleModifier = 10^3
clusterScaleModifier = 10^3
positionScale = 10^12
areaScale = positionScale * areaScaleModifier
clusterScale = areaScale * clusterScaleModifier

clusterScaled, areaScaled, positionScaled :: Double
positionScaled = fromIntegral positionScale
areaScaled = fromIntegral areaScale
clusterScaled = fromIntegral clusterScale


data Cluster = Cluster Word
    deriving (Show, Eq)
data Area = Area Word
    deriving (Show, Eq)
data Position = Position Double
    deriving (Show, Eq)
data GalaxyGrid = GalaxyXGrid Quadrant Cluster Area Position
                | GalaxyYGrid Quadrant Cluster Area Position
                | GalaxyLayer Quadrant Cluster Area Position
    deriving (Show, Eq)

instance Scalable Cluster where
    fromWorldAxis wd@(WorldAxis _ _ x) = Cluster (truncate (x / areaScaled))
    
instance Scalable Area where
    fromWorldAxis wd@(WorldAxis _ _ x) = Area ((truncate (x / positionScaled)) `div` clusterScaleModifier)
    
instance Scalable Position where
    fromWorldAxis wd@(WorldAxis _ _ x) = Position ()
        
instance Scalable GalaxyGrid where
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
    
    