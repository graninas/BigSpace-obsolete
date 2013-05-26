module Game.Input.Input (
    pollInput
    , TimeInput(..)
    , Input(..)
    ) where

import qualified SDL.Common as SDL
import qualified Game.Wire as W

data Input t e = Input
                { inputTime :: t
                , inputEvent :: e
                }
    deriving Show

type TimeInput = Input W.Time SDL.Event

pollInput :: W.Time -> IO TimeInput
pollInput dt = do
    sdlE <- SDL.pollEvent
    return (Input dt sdlE)
