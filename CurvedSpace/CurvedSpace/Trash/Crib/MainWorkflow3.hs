{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies #-}

module Trash.Crib.MainWorkflow3 where

import System.Time
import System.Locale
import Text.Printf
import Control.Monad
import qualified Control.Monad.State as State
import qualified Data.Map as Map


class Context a b | a -> b where   -- TODO: remove dependency from WorkflowContextItem 
  lookup :: String -> a -> b
  insert :: String -> b -> a -> a

data Workflow ctx = Workflow ctx

instance Monad Workflow where
  return = Workflow
  (>>=) (Workflow ctx) f = f ctx

newtype WorkflowT m ctx = WorkflowT { runWorkflowT :: m (Workflow ctx) }

instance Monad (WorkflowT m) where
  return = WorkflowT . return . Workflow    -- TODO: replace Workflow by general return
  x >>= f = WorkflowT $ do
        (Workflow ctx) <- runWorkflowT x
        let newWft = f ctx
        runWorkflowT newWft

type WF ctx a = WorkflowT IO ctx