{-# LANGUAGE Arrows, ExistentialQuantification, FunctionalDependencies #-}

module Workflow.WorkflowFacade where

-- Workflow facade

import System.Environment
import Control.Monad
import qualified Control.Monad.IO.Class
import qualified Control.Monad.State as State
import qualified Data.Map as Map

import Prelude hiding (log, lookup, id, (.))

import Control.Arrow
import Control.Category

import qualified Control.Monad.Named as Named
import Workflow.Logger

newtype Workflow a b = Workflow { runWorkflow :: a -> b }
type Inpure a b = Kleisli IO a b



wf1 = proc wf -> do
    Kleisli (log inf) -< "Start workflow " ++ wf
    Kleisli (log inf) -< "Done!!!"
    
wf2 = proc _ -> log inf -< "Here we go!" 

boot = runKleisli wf1 "WF1"

