module Game.Workflow.GameCycle where

import Control.Wire
import Control.Monad.Identity (Identity)
import Prelude hiding ((.), id)


gameCycleWorkflow :: Wire () Identity a Time
gameCycleWorkflow = when (< 15) . timeFrom 10
