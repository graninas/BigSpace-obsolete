module Main where

import Common.World
import Test.QuickCheck

instance Arbitrary WorldAxis where
    arbitrary = choose (0, quadrantScale) >>= return . (WorldAxis XAxis)



checkNegate :: WorldAxis -> Bool
checkNegate s = (negate . negate $ s) == s
checkAbs s = (abs . negate $ s) == (abs s)

checkWorldAxisToGalaxyGrid s = let
    wp = fromWorldAxis s :: GalaxyGrid
    in s == (toWorldAxis wp)


main = do
    let tests = [ checkNegate
                , checkAbs
                , checkWorldAxisToGalaxyGrid
                ]



    mapM_ quickCheck tests

    putStrLn "Tests done."