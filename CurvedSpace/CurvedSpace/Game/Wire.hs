module Game.Wire where

import qualified Game.Common as C
import Game.World

startWire :: World w =>
             (Inhibitor -> IO ())
            -> C.Wire Inhibitor IO w w
            -> w
            -> IO ()
startWire inhibitor wire = loop wire C.clockSession
  where
    loop w session world = do
        (mx, w', session') <- C.stepSession w session world
        case mx of
          Left ex -> inhibitor ex
          Right newWorld -> loop w' session' newWorld

outputWire :: World w => C.Wire Inhibitor IO w w
outputWire = C.mkFixM postOutput

modifyWire :: World w => C.Wire Inhibitor IO w w
modifyWire = C.mkFixM modify

inputWire :: World w => C.Wire Inhibitor IO w w
inputWire = C.mkFixM pollInput

gameWire :: World w => C.Wire Inhibitor IO w w  
gameWire = outputWire
         C.. modifyWire
         C.. inputWire





    