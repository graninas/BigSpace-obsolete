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
          Left (W.SwitchWire nextWire nextWorld) -> do
            putStrLn "Switching to another wire."
            loop nextWire session' nextWorld
          Left W.Quit -> do
            putStrLn "Quiting."
            return ()
          Right newWorld -> loop w' session' newWorld
          
mainLoopWire :: World world => W.Wire (W.Inhibitor world) IO world world
mainLoopWire =   postOutput
         W.. modify
         W.. pollInput 