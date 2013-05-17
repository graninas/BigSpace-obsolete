module Trash.Crib.Curses where

import qualified UI.Nanocurses.Curses as NanoCurses
import qualified UI.HSCurses.Curses as HSCurses
import qualified UI.HSCurses.Curses.Helper as HSCurses


setupEnvironment1 = do
    NanoCurses.initCurses (return ())
    NanoCurses.resetParams
    NanoCurses.keypad NanoCurses.stdScr True


tearDownEnvironment1 = do
    NanoCurses.endWin
    
setupEnvironment = HSCurses.start
tearDownEnvironment = HSCurses.end



keyPressed :: IO a -> IO (Maybe a)
keyPressed getChF = do
    ch <- getChF
    return (Just ch)