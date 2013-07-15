module Utils.Logging.Logger where

import Utils.Time.Time
import System.Locale
import Prelude hiding (log)
import Utils.Logging.Formatter


log :: Formatter -> String -> IO ()
log formatter msg = do
    entryTime <- getDefaultTimeStamp "[%d.%m.%Y %H:%M:%S]"
    let formattedMessage = formatter entryTime msg
    putStrLn formattedMessage