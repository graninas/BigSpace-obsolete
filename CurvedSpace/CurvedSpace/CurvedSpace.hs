module Main where

import Game.Boot

-- For tests only
import Game.Wires
import Wire.Wire

main::IO ()
main = do

    putStrLn "Loading..."
    
    boot
    
    putStrLn $ "All Ok."