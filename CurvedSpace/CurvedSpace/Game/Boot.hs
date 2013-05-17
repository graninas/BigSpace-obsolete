{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import Game.Environment
import Game.Wires

import Wire.Wire

boot = withEnvironment $ do
    setupScreen 640 480 32 "CurvedSpace"
    startWire return (putStrLn . show) mainMenuWire
    