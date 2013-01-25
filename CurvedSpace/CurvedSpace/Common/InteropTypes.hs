module Common.InteropTypes where

import qualified Data.ByteString.Char8 as B
import qualified Control.Concurrent.MVar as M (MVar)
import System.Time

import Common.Types

type GameLoopMsg = M.MVar (FrameInfo, String)
type WorldServerMsg = M.MVar String

type InteropMsg = (GameLoopMsg, WorldServerMsg)