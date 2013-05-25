module Game.Input.Keys where

import Game.Input.Input
import qualified SDL.Common as SDL
import qualified SDL.Keys as SDL
import qualified SDL.Events as SDL

notEmpty :: TimeInput -> Bool
notEmpty = (SDL.noEvent /=) . inputEvent

isUpKey, isDownKey :: TimeInput -> Bool
isUpKey = SDL.isUpKey . inputEvent
isDownKey = SDL.isDownKey . inputEvent
