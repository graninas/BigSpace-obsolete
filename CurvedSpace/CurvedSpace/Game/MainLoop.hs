module Game.MainLoop where

import qualified Game.Wire as W
import Game.World


-- | Evals main loop. Takes a wire to loop and start world.
startMainLoop :: World world => W.GameWire world -> world -> IO ()
startMainLoop wire = loop wire W.clockSession
  where
    loop w session world = do
        (mx, w', session') <- W.stepSession w session world
        case mx of
          Left ex -> error "Inhibition is undefined."
          Right newWorld -> loop w' session' newWorld
          
mainLoopWire :: World world => W.Wire W.Inhibitor IO world world
mainLoopWire = worldWire 