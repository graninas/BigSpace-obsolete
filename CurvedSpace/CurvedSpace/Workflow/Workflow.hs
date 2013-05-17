module Workflow.Workflow where

import Control.Wire
import Control.Monad.Identity (Identity)
import Prelude hiding ((.), id)

import Graphics.UI.SDL

import Utils.SDLKeys


keyPressed = do
    event <- pollEvent
    return $ case event of
        KeyDown (Keysym key _ _) -> translateChar key 
        Quit -> Nothing
        NoEvent -> Nothing
        _ -> Nothing

wfWire = mkFixM $ \_ _ -> do
        ky <- keyPressed
        return (Right ky)

startWorkflow inh prod wf = loop wf clockSession
  where
    loop w' session' = do
        (mx, w, session) <- stepSession w' session' ()
        case mx of
          Left ex -> inh ex
          Right x -> prod x
        loop w session

        
        