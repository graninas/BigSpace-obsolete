module Main where

import Workflow.WorkflowFacade
import Workflow.MainWorkflow


main::IO ()
main = do

    putStrLn "Loading..."
    
    
    boot mainWorkflow
    
    
    putStrLn "All Ok."