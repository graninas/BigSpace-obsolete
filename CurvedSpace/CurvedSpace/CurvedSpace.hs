module Main where

import Game.Boot

main::IO ()
main = do

    putStrLn "Loading..."
    
    
    ch <- boot
    putStrLn $ "Ch: " ++ show ch
    
    
    putStrLn $ "All Ok."