module Game.Input (pollInput, GameInput (..), GameEvent(..)) where

import qualified Graphics.UI.SDL as SDL
import qualified Graphics.UI.SDL.Video as SDL
import qualified Graphics.UI.SDL.Events as SDL

data BaseInput t i = BaseInput t i
newtype BaseEvent e = BaseEvent e

type GameEvent = BaseEvent SDL.Event
type GameInput t = BaseInput t GameEvent


pollInput :: dt -> w -> IO (GameInput dt)
pollInput dt _ = do
    sdlE <- SDL.pollEvent
    let e = BaseEvent sdlE
    return (BaseInput dt e)
