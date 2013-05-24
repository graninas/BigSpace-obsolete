{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import Game.Environment
import Game.Wire
import Game.Menu.Menu

boot = withEnvironment $ do
    setupScreen 640 480 32 "CurvedSpace"
    let startWorld = Menu ["Generate new world", "Quit"] 
    startWire return gameWire startWorld
    