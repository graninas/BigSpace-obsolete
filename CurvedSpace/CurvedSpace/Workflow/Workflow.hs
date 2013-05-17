module Workflow.Workflow (startWorkflow) where

import Control.Wire


startWorkflow wf inh prod = loop wf clockSession
  where
    loop w' session' = do
        (mx, w, session) <- stepSessionP w' session' ()
        case mx of
          Left ex -> inh ex
          Right x -> prod x
        loop w session

        
        