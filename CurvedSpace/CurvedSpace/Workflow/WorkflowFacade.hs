{-# LANGUAGE Arrows, ExistentialQuantification #-}

module Workflow.WorkflowFacade where

-- Workflow facade

import System.Environment
import Control.Monad
import qualified Control.Monad.IO.Class
import qualified Control.Monad.State as State
import qualified Data.Map as Map
import System.Time
import System.Locale

import Prelude hiding (log, lookup, id, (.))
import Text.Printf

import qualified Control.Monad.Named as Named

import Control.Arrow
import Control.Category





type WorkflowName = String
type ItemKey = String

data ContextItem = Logger (String -> IO ())
                 | StringConst String               
                 | forall m. (Monad m) => WorkflowList (WorkflowList String (m ()))

type ContextItems = Map.Map ItemKey ContextItem
data Context = Context 
             { contextItems :: ContextItems
             , parentContext :: Maybe Context
             }



newtype Workflow a b = Workflow { runWorkflow :: a -> b }
type WorkflowList a b = Map.Map WorkflowName (Workflow a b)

instance Arrow Workflow where
  arr = Workflow
  first (Workflow f) = Workflow (mapFst f)
    where mapFst g (a,b) = (g a, b)
  second (Workflow f) = Workflow (mapSnd f)
    where mapSnd g (a, b) = (a, g b)
    
    
instance Category Workflow where
    (Workflow f) . (Workflow g) = Workflow (f . g)
    id = arr id
  


type Formatter = (ClockTime, String) -> String -> String
err, inf :: Formatter
err (_, t) = printf "%s ERR %s" t
inf (_, t) = printf "%s INF %s" t
sinf _ = printf "INF %s"

log :: Formatter -> Workflow String ( IO () )
log formatter = proc msg -> do
--    (Logger logger) <- get "" "Logger"
--    clockTime <- liftIO getClockTime
--    calTime <- liftIO (toCalendarTime clockTime)
--    let entryTime = formatCalendarTime defaultTimeLocale "[%d.%m.%Y %H:%M:%S]" calTime
--    let formattedMessage = formatter (clockTime, entryTime) msg
--    liftIO $ logger formattedMessage
    returnA -< putStrLn msg


start wfName _ _ = runWorkflow wf1 wfName 


wf1 :: Workflow String (IO ())
wf1 = proc a -> do
    res1 <- log inf -< ("Start workflow " ++ a)
    --exec a emptyContext
    res2 <- log inf -< "Done!!."
    returnA -< (res2 >> res1)

wf2 :: Workflow String (IO ())
wf2 = proc _ -> log inf -< "Here we go!"

wfList :: WorkflowList String (IO ())
wfList = Map.fromList [("WF1", wf1), ("WF2", wf2)]


boot startWF wfList = let
    initialContext = Map.fromList [("FilePath", StringConst "/etc/xxx"), ("Logger", Logger putStrLn)]
    in do
    res <- start startWF wfList initialContext
    putStrLn "AAA"

