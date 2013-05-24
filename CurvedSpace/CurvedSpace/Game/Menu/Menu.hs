module Game.Menu.Menu where

import qualified Game.Wire as W
import Game.World

data Menu = Menu [String]


instance World Menu where
    pollInput _ menu = return . Right $ menu
    modify _ menu = return . Right $ menu
    postOutput _ menu@(Menu items) = do
        putStrLn $ "Taking menu:" ++ unwords items
        return . Right $ menu