module Game.Menu.Menu where

import qualified Control.Monad as M (when)

import qualified Game.Wire as W
import qualified Game.Input as I
import Game.World

import Utils.Constants

type InputList = [I.GameInput W.Time] 
data Menu = Menu
            { inputs :: InputList
            , items :: [String]
            }


instance World Menu where

    postOutput _ menu@(Menu _ items) = do
        putStrLn $ "Taking menu:" ++ unwords items
        return . Right $ menu

    modify _ menu = return . Right $ menu

    pollInput dt menu@(Menu oldInputs _) = do
        i <- I.pollInput dt
        if I.notEmpty i
            then return . Right $ (menu { inputs = i : oldInputs } ) 
            else return . Right $ menu
