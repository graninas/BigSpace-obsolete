module Game.Input (
    pollInput,
    GameInput (..),
    notEmpty
) where

import qualified Graphics.UI.SDL as SDL
import qualified Graphics.UI.SDL.Video as SDL
import qualified Graphics.UI.SDL.Events as SDL

data Input t i = Input t i
    deriving Show

type GameInput t = Input t SDL.Event

pollInput :: t -> IO (GameInput t)
pollInput dt = do
    sdlE <- SDL.pollEvent
    return (Input dt sdlE)

notEmpty :: (GameInput t) -> Bool
notEmpty (Input _ e) = e /= SDL.NoEvent