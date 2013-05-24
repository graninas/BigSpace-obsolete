{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import Game.Environment
import Game.MainLoop
import Game.Menu.Menu

boot = withEnvironment $ do
    setupScreen 640 480 32 "CurvedSpace"
    let startWorld = Menu ["Generate new world", "Quit"] 
    startMainLoop return mainLoopWire startWorld
    putStrLn "Be seen you..."