module Wire.Wire where

import Control.Wire
import Control.Monad.Identity (Identity)
import Prelude hiding ((.), id)


makeWire io = mkFixM $ \_ _ -> io 

startWire inhibitor producer wire = loop wire clockSession
  where
    loop w session = do
        (mx, w', session') <- stepSession w session ()
        case mx of
          Left ex -> inhibitor ex
          Right x -> producer x
        loop w' session'