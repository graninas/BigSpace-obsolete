module Types where

data QuadrantScale = Alpha | Beta | Gamma | Delta
type StarClusterScale = (Int, Int, Int) -- 0 -|- 50
type StarSystemScale  = (Int, Int, Int) -- 0 -|- 999
type OuterSpaceScale  = (Int, Int, Int) -- 0 -|- 63
type InnerSpaceScale  = (Int, Int, Int) -- 0 -|- 149 600 000

data GlobalPos = GP QuadrantScale StarClusterScale StarSystemScale OuterSpaceScale
type LocalPos  = InnerSpaceScale

type Vector3 = (Int, Int, Int)

type Time = Int
type Speed = Int
type IncValue = Int
type DirVector = Vector3
