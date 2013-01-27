module Common.TickTime where

import qualified System.CPUTime as T
import Common.Types

type TickTime = Integer

data GameTact = GameTact
    {
        gtPrevTick :: Word,
        gtPrevTickTime :: TickTime,
        gtTicksInPrevTact :: Word,
        gtPrevTact :: Word,
        gtPrevTactTime :: TickTime,
        gtNextTactTime :: TickTime,
        gtFps :: Float
    }
  deriving (Show, Eq)

data Elapsed = Elapsed
     { eTicksCount :: Word
     , ePrevTactTime :: TickTime
     , eCurrentTactTime :: TickTime
     }
  deriving (Show, Eq)

tickTimeSecondRatio :: Word
tickTimeSecondRatio = 10^12

tickTimePrecision :: TickTime
tickTimePrecision = T.cpuTimePrecision

getIOTickTime :: IO TickTime
getIOTickTime = T.getCPUTime

addTickTime, subTickTime :: TickTime -> TickTime -> TickTime
addTickTime = (+)
subTickTime = (-)

-- Every tick recalculates ticks count and checks if new tact (frame) occured.
-- One tact may consisting of many tics.
-- In every tact recalculates the fps.
-- Returns (True, _, _) if new tact occured and (False, _, _) otherwise.
evalGameTact :: (Float, Float, TickTime) -> GameTact -> TickTime -> (Bool, Elapsed, GameTact)
evalGameTact (fpsRatio1, fpsRatio2, frequency)
    gt@(GameTact tick tickTime ticks tact prevTactTime nextTactTime fps) curTickTime = let
        newTick = (tick + 1)
        newTact = (tact + 1)
        newTicksFrame = (ticks + 1)
        
        isNewFrame = curTickTime >= nextTactTime
        newNextTactTimeIfNewFrame = addTickTime frequency curTickTime
        
        elapsedIfNewFrame = Elapsed ticks prevTactTime curTickTime
        elapsedIfPrevFrame = Elapsed newTicksFrame prevTactTime curTickTime
        
        newGameTactIfNewFrame = GameTact newTick curTickTime 0 newTact curTickTime newNextTactTimeIfNewFrame newFps
        newGameTactIfPrevFrame = GameTact newTick tickTime newTicksFrame tact prevTactTime nextTactTime fps
        
        in case isNewFrame of
            True -> (True, elapsedIfNewFrame, newGameTactIfNewFrame)
            False -> (False, elapsedIfPrevFrame, newGameTactIfPrevFrame)
  where
    elapsedTime = subTickTime curTickTime prevTactTime
    actualFps = (fromIntegral (ticks * tickTimeSecondRatio) / fromIntegral elapsedTime)
    newFps = fps * fpsRatio1 + actualFps * fpsRatio2