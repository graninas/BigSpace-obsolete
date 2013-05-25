module Game.Boot where

import Utils.Constants

import Game.Environment
import Game.MainLoop
import Game.Menu.Menu

import qualified Game.Input.InputBuffer as I

boot = withEnvironment $ do
    writeFile logFile "Log."
    setupScreen screenSettings "CurvedSpace"
    let startWorld = Menu [] ["Generate new world", "Quit"]
    let startBuf = I.mkBuf startWorld
    startMainLoop return mainLoopWire startWorld
    putStrLn "Be seen you..."