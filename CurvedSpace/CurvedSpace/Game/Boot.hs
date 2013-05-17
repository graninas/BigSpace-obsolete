{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import qualified UI.Nanocurses.Curses as Curses

import Workflow.Workflow
import Game.Workflow.GameCycle


keyPressed :: IO (Maybe Char)
keyPressed = do
    ch <- Curses.getCh
    return (Just ch)

setupEnvironment = do
    Curses.initCurses (return ())
    Curses.resetParams
    Curses.keypad Curses.stdScr True    -- grab the keyboard


tearDownEnvironment = Curses.endWin


boot = do
    putStrLn "Begin..."
    setupEnvironment
    
    ch <- keyPressed
    putStrLn $ "Char got."

    
    tearDownEnvironment
    putStrLn "End..."
    return ch