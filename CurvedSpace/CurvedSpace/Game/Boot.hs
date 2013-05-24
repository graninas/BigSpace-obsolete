{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import Game.Environment
import Game.Wire

boot = withEnvironment $ do
    setupScreen 640 480 32 "CurvedSpace"
    startWire return (putStrLn . show) gameWire
    