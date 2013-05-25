module Game.World where

import qualified Game.Wire as W

type Inhibitor = ()


class World a where
    modify :: W.Time -> a -> IO (Either Inhibitor a)
    postOutput :: W.Time -> a -> IO (Either Inhibitor a)
    --pollInput :: W.Time -> a -> IO (Either Inhibitor a)
    pollInput :: W.Wire Inhibitor IO a a
    
