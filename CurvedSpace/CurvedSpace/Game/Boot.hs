{-# LANGUAGE ForeignFunctionInterface #-}
module Game.Boot where

import Control.Wire
import Prelude hiding ((.), id)

import Game.Environment
import Game.Workflow.GameCycle

import Workflow.Workflow



boot = do
    runEnvironment 640 480 32 game
  where
    game = startWorkflow (return) (putStrLn . show) wfDef
    wfDef = when ( /= Nothing) . wfWire
    