module Main where

import Game.Boot

main::IO ()
main = do

    putStrLn "Loading..."
    
    boot
    
    putStrLn $ "All Ok."