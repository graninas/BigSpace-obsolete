module Game.Wire where

import Control.Wire
import qualified Control.Monad as M
import Prelude hiding ((.), id)

import Game.Input
import Game.World
import Game.Output

startWire inhibitor wire sw = loop wire clockSession sw
  where
    loop w session world = do
        (mx, w', session') <- stepSession w session world
        case mx of
          Left ex -> inhibitor ex
          Right newWorld -> loop w' session' newWorld

outputWire :: Wire () IO w w
outputWire = mkFixM $ \dt world -> do
    postOutput dt world
    return (Right world)

modifyWire :: Wire () IO (w, i) w
modifyWire = mkFixM $ \dt (world, i) -> do
    newWorld <- modify dt world i
    return $ Right newWorld

inputWire :: Wire () IO w (w, GameInput Time)
inputWire = mkFixM $ \dt world -> do
    i <- pollInput dt world
    return $ Right (world, i)

gameWire = outputWire
         . modifyWire
         . inputWire





    