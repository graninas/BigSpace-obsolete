module Game.Menu.Menu where

import qualified Game.Common as C
import Game.World

data Menu = Menu [String]


instance World Menu where
    --pollInput :: C.Time -> a -> IO (Either Inhibitor a)
    pollInput _ menu = return . Right $ menu
    
    --modify :: C.Time -> a -> IO (Either Inhibitor a)
    modify _ menu = return . Right $ menu
    
    --postOutput :: C.Time -> a -> IO (Either Inhibitor a)
    postOutput _ menu@(Menu items) = do
        putStrLn $ "Taking menu:" ++ unwords items
        return . Right $ menu