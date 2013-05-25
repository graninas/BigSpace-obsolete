module Game.Menu.Menu where

import qualified Control.Monad as M (when)

import qualified Game.Wire as W
import qualified Game.Input.Input as I
import qualified Game.Input.Keys as I
import qualified Game.Input.InputBuffer as I
import Game.World

import Utils.Constants

data Menu = Menu { menuItems :: String
                 , menuSelected :: Int
                 }

moveItem :: I.TimeInput -> Menu -> Menu
moveItem input menu | I.isUpKey input = toPrev menu
                    | I.isDownKey input = toNext menu  
                    | otherwise = error "Key is not supported."

toPrev, toNext :: Menu -> Menu
toPrev menu@(Menu its sel) | sel == 0  = menu { menuSelected = length its - 1 }
                           | otherwise = menu { menuSelected = sel - 1 }

toNext menu@(Menu its sel) | sel == length its = menu { menuSelected = 0 }
                           | otherwise = menu { menuSelected = sel + 1 }

instance World Menu where
    postOutput _ buf = do
        let menu@(Menu items _) = I.bufferItem buf
        putStrLn $ "Taking menu:" ++ unwords items
        return . Right $ menu

    modify _ buf = do
            let menu = I.bufferItem buf
            let inputs = I.bufferInputs buf
            let newMenu = foldr moveItem menu inputs
            return . Right $ I.mkBuf newMenu

    pollInput = W.mkFixM $ \dt buf -> do
        i <- I.pollInput dt
        if I.notEmpty i
            then return . Right $ I.addInput buf i
            else return . Right $ buf
            
            
