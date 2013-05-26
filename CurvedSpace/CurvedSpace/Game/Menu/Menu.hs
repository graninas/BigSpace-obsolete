module Game.Menu.Menu where

import qualified Control.Monad as M (when)

import qualified Game.Wire as W
import qualified Game.Input.Input as I
import qualified Game.Input.Keys as I
import qualified Game.Input.InputBuffer as I
import Game.World

import Utils.Constants

data MenuItem = MenuItem { menuItemName :: String
                         }

data Menu = Menu { menuItems :: [MenuItem]
                 , menuSelected :: Int
                 , menuInputBuffer :: I.InputBuffer
                 }

moveMenuItem :: Menu -> I.TimeInput -> Menu
moveMenuItem menu input | I.isUpKey input = toPrev menu
                        | I.isDownKey input = toNext menu  
                        | otherwise = menu

toPrev, toNext :: Menu -> Menu
toPrev menu@(Menu its sel _) | sel == 0  = menu { menuSelected = length its - 1 }
                             | otherwise = menu { menuSelected = sel - 1 }

toNext menu@(Menu its sel _) | sel == length its = menu { menuSelected = 0 }
                             | otherwise = menu { menuSelected = sel + 1 }

instance World Menu where
    postOutput = W.mkFixM postOutput'
    modify = W.mkFixM modify'
    pollInput = W.mkFixM pollInput'

postOutput' :: W.Time -> Menu -> IO (Either (W.Inhibitor w) Menu)
postOutput' _ menu@(Menu items selected _) = do
    mapM_ putMenuItem (zip [0..] items)
    return . Right $ menu
  where
    putMenuItem (i, MenuItem name) | i == selected = putStrLn $ "> " ++ name
                                   | otherwise     = putStrLn $ "  " ++ name 

modify' :: W.Time -> Menu -> IO (Either (W.Inhibitor w) Menu)
modify' _ menu@(Menu _ _ inputBuffer) = do
    let modifiedMenu = foldl moveMenuItem menu (I.bufferInputs inputBuffer)
    return . Right $ modifiedMenu { menuInputBuffer = I.emptyInputBuffer }

pollInput' :: W.Time -> Menu -> IO (Either (W.Inhibitor w) Menu)
pollInput' dt menu@(Menu _ _ inputBuffer) = do
        i <- I.pollInput dt
        if I.notEmpty i
            then return . Right $ menu { menuInputBuffer = I.addInput inputBuffer i}
            else return . Right $ menu
