module Utils.Logging.Logger2 where

import Utils.Logging.Format
import Utils.Time.Time

type Log :: Formatter -> String -> IO ()

data Logger = Logger
    { init :: IO Logger
    , log :: Log
    }

data FileLogger = FileLogger
    {
        logFilePath :: FilePath
    }


initFileLogger :: FileLogger -> IO Logger
initFileLogger fileLogger = do
    let filePath = logFilePath fileLogger
    logBeginTimeMessage <- getDefaultTimeStamp "Log started at %d.%m.%Y %H:%M:%S.\n"
    writeFile filePath logBeginTimeMessage
    return $ Logger { init = return ()
                    , log fmt msg = appendFile filePath (fmt msg)
                    }


fileLogger :: FileLogger -> Formatter -> String -> Logger
fileLogger fileLogger fmt msg = Logger
        { init = initFileLogger fileLogger
        , 
        }
