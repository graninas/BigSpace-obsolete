module Common.InteropTypes where

import qualified Data.ByteString.Char8 as B
import qualified Control.Concurrent.MVar as M (MVar)

import System.Time

--                           ((Iteration, CurTime), Message)
type GameCycleStats = M.MVar ((Float, System.Time.ClockTime), Maybe B.ByteString)