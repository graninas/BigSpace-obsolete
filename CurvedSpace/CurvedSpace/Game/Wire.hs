module Game.Wire
    ( module Control.Wire
    , module Control.Monad
    , GameWire(..)
    , Inhibitor(..)
    ) where

import Control.Wire
import Control.Monad hiding (unless, when)
import Prelude hiding ((.), id)

data Inhibitor w = SwitchWire (GameWire w) w
                 | Quit
type GameWire w = Wire (Inhibitor w) IO w w
