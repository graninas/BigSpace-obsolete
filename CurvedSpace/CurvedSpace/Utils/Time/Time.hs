module Utils.Time.Time where

import qualified System.Time as T

getCalendarTime :: IO T.CalendarTime
getCalendarTime = T.getClockTime >>= T.toCalendarTime

getDefaultTimeStamp format = do
    calTime <- getCalendarTime
    return $ T.formatCalendarTime T.defaultTimeLocale format 

