module Common.Constants where

import System.Time

framesFrequency = System.Time.TimeDiff 0 0 0 0 0 0 50000000000

-- (host, port)
serverAddress = (0, 4343 :: Int)