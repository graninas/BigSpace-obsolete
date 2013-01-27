module Common.InteropTypes where

import qualified Data.ByteString.Char8 as B
import qualified Control.Concurrent.MVar as M (MVar)
import System.Time

import Common.Types
import Common.TickTime

type GameLoopMsg = M.MVar (GameTact, String)
type WorldServerMsg = M.MVar String

type InteropMsg = (GameLoopMsg, WorldServerMsg)