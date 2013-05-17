module Utils.Logger (
    err,
    inf,
    inf1,
    log
  ) where

import System.Time
import System.Locale
import Text.Printf
import Prelude hiding (log)

type Formatter = (ClockTime, String) -> String -> String
err, inf :: Formatter
err (_, t) = printf "%s ERR %s" t
inf (_, t) = printf "%s INF %s" t
inf1 _ = printf "INF %s"

log :: Formatter -> String -> IO ()
log formatter msg = do
    clockTime <- getClockTime
    calTime <- toCalendarTime clockTime
    let entryTime = formatCalendarTime defaultTimeLocale "[%d.%m.%Y %H:%M:%S]" calTime
    let formattedMessage = formatter (clockTime, entryTime) msg
    putStrLn formattedMessage