module Main where

import Common.World
import Test.QuickCheck

instance Arbitrary WorldDim where
    arbitrary     = choose (0, quadrantScale) >>= return . WorldDim



checkNegate :: WorldDim -> Bool
checkNegate s = (negate . negate $ s) == s
checkAbs s = (abs . negate $ s) == (abs s)

checkWorldDimToPos s = let
    wp = fromWorldDim s :: WorldPos
    in s == (toWorldDim wp) 


main = do
    let tests = [ checkNegate
                , checkAbs
                , checkWorldDimToPos
                ]
                
                
                
    mapM_ quickCheck tests

    putStrLn "Tests done."