module Game.World where

import qualified Game.Common as C

type Inhibitor = ()


class World a where
    pollInput :: C.Time -> a -> IO (Either Inhibitor a)
    modify :: C.Time -> a -> IO (Either Inhibitor a)
    postOutput :: C.Time -> a -> IO (Either Inhibitor a)
