module Main where

import Workflow.WorkflowFacade
import Workflow.MainWorkflow


main::IO ()
main = do

    putStrLn "Loading..."
    
    
    boot "WF1" wfList
    
    
    putStrLn "All Ok."