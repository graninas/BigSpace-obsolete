module Game.MainLoop where

import qualified Game.Wire as W
import Game.World

startMainLoop :: World w =>
             (Inhibitor -> IO ())
            -> W.Wire Inhibitor IO w w
            -> w
            -> IO ()
startMainLoop inhibitor wire = loop wire W.clockSession
  where
    loop w session world = do
        (mx, w', session') <- W.stepSession w session world
        case mx of
          Left ex -> inhibitor ex
          Right newWorld -> loop w' session' newWorld

outputWire :: World w => W.Wire Inhibitor IO w w
outputWire = W.mkFixM postOutput

modifyWire :: World w => W.Wire Inhibitor IO w w
modifyWire = W.mkFixM modify

inputWire :: World w => W.Wire Inhibitor IO w w
inputWire = W.mkFixM pollInput

mainLoopWire :: World w => W.Wire Inhibitor IO w w  
mainLoopWire = outputWire
           W.. modifyWire
           W.. inputWire





    