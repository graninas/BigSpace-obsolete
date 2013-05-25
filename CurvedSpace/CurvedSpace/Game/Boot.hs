module Game.Boot where

import Utils.Constants

import Game.Environment
import Game.MainLoop
import Game.Menu.Menu

boot = withEnvironment $ do
    writeFile logFile "Log."
    setupScreen screenSettings "CurvedSpace"
    let startWorld = Menu [] ["Generate new world", "Quit"] 
    startMainLoop return mainLoopWire startWorld
    putStrLn "Be seen you..."