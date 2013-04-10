module Workflow.MainWorkflow2 where

import System.Time
import System.Locale
import Text.Printf
import Control.Monad
import qualified Control.Monad.State as State
import qualified Data.Map as Map

logEntryDateTimeFormat = formatDateTime defaultTimeLocale "%d.%m.%Y-%H:%M:%S"
logFileDateTimeFormat =  formatDateTime defaultTimeLocale "%d.%m.%Y-%H_%M_%S"

-- TODO: different logs for different WFs. 

type ContextDictionary = Map.Map String WorkflowContextItem
data WorkflowContextItem = Logger (String -> IO ()) -- Replace IO () by common logger type. 

class Context a where   -- TODO: remove dependency from WorkflowContextItem 
  lookup :: String -> a -> WorkflowContextItem
  insert :: String -> WorkflowContextItem -> a -> a

instance Context ContextDictionary where
  lookup = Map.lookup
  insert = Map.insert


getContext :: Context ctx => String -> WF ctx WorkflowContextItem
getContext key = do
    context <- State.get
    case lookup key context of
        Just res -> return res
        Nothing -> error $ "No item required: " ++ item

putContext :: Context ctx => String -> WorkflowContextItem -> WF ctx ()
putContext key value = do
    context <- State.get
    let newContext = insert key value context
    State.put context

type LogLevel = String -> String -> String
err, inf :: LogLevel
err = printf "[%s] ERR %s"
inf = printf "[%s] INF %s"


data (Context ctx) => Workflow ctx = Workflow ctx 

newtype (Monad m) => WorkflowT m ctx = WorkflowT { runWorkflowT :: m (Workflow ctx) }
-- newtype (Monad m) => MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }
instance Monad m => Monad (WorkflowT m) where
  return = WorkflowT . return . Workflow    -- TODO: replace Workflow by general return
  x >>= f = WorkflowT $ do
        (Workflow ctx) <- runWorkflowT x
        let newWft = f ctx
        in runWorkflowT newWft

newtype (Context ctx) => WF ctx a = WorkflowT (IO a) ctx



log :: LogLevel -> String -> WF ()
log lvl msg = do
    (Logger logger) <- getContext "Logger"
    calTime <- liftIO (getClockTime >>= toCalendarTime)
    let entryTime = logEntryDateTimeFormat calTime
    liftIO $ logger (lvl entryTime msg)

setupFileLogger :: WF ()
setupFileLogger = do
    -- TODO: fix path to logs
    calTime <- liftIO (getClockTime >>= toCalendarTime)
    let logCreationTime = logFileDateTimeFormat calTime
    let filePath = printf "%s%s_%s%s" "./" "WF_log" logCreationTime ".txt"
    let fileLogger = appendFile filePath
    putContext "Logger" (Logger fileLogger)
    

mainWorkflow :: WF ()
mainWorkflow = do
    log err "Can't log - should fail here."
    setupFileLogger
    log inf "Log setuped."
    readWf "Game WF" >>= start

    
    

boot :: (a -> IO ()) -> b -> IO ()
boot manager workflow = do
    args <- getArgs
    
    let context = toCommandLineContext args 
    
    manager (workflow context) 

workflowManager :: a -> IO ()
workflowManager contextedWorkflow = do
    result <- exec contextedWorkflow
    
    workflowManager result


    
