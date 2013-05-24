module Game.Wire where

import Control.Wire
import qualified Control.Monad as M
import Prelude hiding ((.), id)

import Utils.Constants
import Game.Input
import Game.World
import Game.Draw


startWire inhibitor producer wire = loop wire clockSession
  where
    loop w session = do
        (mx, w', session') <- stepSession w session ()
        case mx of
          Left ex -> inhibitor ex
          Right x -> producer x
        loop w' session'

drawWire :: Wire () IO w w
drawWire = mkFixM $ \_ w -> do
    drawWorld w
    return (Right w) 

manipulateWire :: Wire () IO (w, i) w
manipulateWire = mkFixM $ \_ (w, i) -> do
    let newW = updateWorld w i
    return $ Right newW

inputWire :: Wire () IO w (w, GameInput Time)
inputWire = mkFixM $ \dt w -> do
    i <- pollInput dt
    return $ Right (w, i)

gameWire = drawWire
         . manipulateWire
         . inputWire





    