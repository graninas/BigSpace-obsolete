module Common.Constants where

import Common.Types
import Common.TickTime


-- | Interval between tact points P1 and P2 on time line in picoseconds.
--    P1                   P2
--  ---|---.---.---.---.---|-------------
--         t1  t2  t3  t4
-- where t1,...,t4 - ticks (iterations) of gameCycle.
-- Increasing tactsFrequency will cause stack bugs and lags.
-- Decreasing shouldn't have any effect because of CPUTime precision bound.
tactsFrequency :: TickTime
tactsFrequency = tickTimePrecision

-- | Speed of sliding fps counter. The lower ratio1, the faster (and less precise) recalculations. 
fpsSlidingRatio1, fpsSlidingRatio2 :: Float
fpsSlidingRatio1 = 0.99
fpsSlidingRatio2 = 1 - fpsSlidingRatio1

-- | Fps settings: slidingRatios and frequency.
fpsSettings :: (Float, Float, TickTime)
fpsSettings = (fpsSlidingRatio1, fpsSlidingRatio2, tactsFrequency)