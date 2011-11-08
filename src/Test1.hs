module Test1 where

import Types
import Object.ObjectTypes
import Geometry.GeometryTypes

data Event = MkObj Object
            | IncAcceleration IncValue DirVector
            | Move Speed DirVector
            
data Fact = Fact Time LocalPos Event

globalPos = GP Gamma (40, 6, 12) (77, 63, 198) (15, 24, 15)

spaceship1Obj = Object "spaceship1" [Sphere (0, 0, 0) 100]
spaceShip1EventLine = (globalPos, 
    [
        Fact 198755512 (125437982, 2756879, 44452111) (MkObj spaceship1Obj),
        Fact 198756544 (125437983, 2756879, 44452121) (IncAcceleration 10 (-32, 5, 23))
    ])

solObj = Object "sol" [Sphere (0,0,0) 695500000]
solEventLine = (globalPos,
    [
        Fact 32323059  (125454544, 8412128, 12147884) (MkObj solObj),
        Fact 32323060  (125454544, 8412128, 12147884) (Move 100 (15, 54, 99))
    ])
