module Main where

import qualified Workflow.WorkflowFacade as W


main::IO ()
main = do

    putStrLn "Loading..."
    
    W.boot W.workflowManager
    
    
    
    putStrLn "All Ok."