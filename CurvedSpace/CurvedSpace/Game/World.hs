module Game.World where

import qualified Game.Wire as W

class World a where
    modify :: W.Wire (W.Inhibitor a) IO a a
    postOutput :: W.Wire (W.Inhibitor a) IO a a
    pollInput :: W.Wire (W.Inhibitor a) IO a a
    