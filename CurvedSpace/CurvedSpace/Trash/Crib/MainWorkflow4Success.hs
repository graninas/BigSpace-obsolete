module Trash.Crib.MainWorkflow4Success where

import System.Environment
import Control.Monad
import qualified Control.Monad.IO.Class
import qualified Control.Monad.State as State
import qualified Data.Map as Map
import System.Time
import System.Locale

import Prelude hiding (log, lookup)
import Text.Printf


type Formatter = (ClockTime, String) -> String -> String
err, inf :: Formatter
err (_, t) = printf "%s ERR %s" t
inf (_, t) = printf "%s INF %s" t
sinf _ = printf "INF %s"

log :: Formatter -> String -> WF ()
log formatter msg = do
    (Logger logger) <- get "" "Logger"
    clockTime <- liftIO getClockTime
    calTime <- liftIO (toCalendarTime clockTime)
    let entryTime = formatCalendarTime defaultTimeLocale "[%d.%m.%Y %H:%M:%S]" calTime
    let formattedMessage = formatter (clockTime, entryTime) msg
    liftIO $ logger formattedMessage



type WorkflowName = String
type ItemKey = String

type WorkflowList = Map.Map WorkflowName (WF ())
data ContextItem = Logger (String -> IO ())
                 | StringConst String               
                 | WorkflowList WorkflowList

type ContextItems = Map.Map ItemKey ContextItem
data Context = Context 
             { contextItems :: ContextItems
             , parentContext :: Maybe Context
             }

type WF a = State.StateT Context IO a

data Workflow a = Workflow { runWorkflow :: (String, WF a) }
                | Finished a

instance Monad Workflow where
    return x = Finished x
    x >>= f = case x of
        Finished y -> f y




-- Abstraction funcs
liftIO :: IO a -> WF a
liftIO = State.liftIO

insert = Map.insert
lookup = Map.lookup
fromList = Map.fromList

evalWF = State.evalStateT
getContext = State.get
putContext = State.put
-- error func

noKeyError :: String -> a
noKeyError = error . printf "No key %s found."

-- utils

getWorkflow :: String -> WF (WF ())
getWorkflow wfName = do
    (WorkflowList list) <- get wfName "WorkflowList"
    case lookup wfName list of
        Just x -> return x
        Nothing -> noKeyError wfName
        
-- WF API
put :: String -> ContextItem -> WF ()
put key val = do
    ctx@(Context oldItems _) <- getContext
    putContext $ (ctx {contextItems = insert key val oldItems}) 

get :: String -> String -> WF ContextItem
get wfName key = do
    ctx <- getContext
    getFromContext (Just ctx)
  where
      getFromContext (Just (Context ctxItems parentCtx)) =
        case lookup key ctxItems of
          Just val -> return val
          Nothing -> getFromContext parentCtx
      getFromContext Nothing = noKeyError key


start :: String -> WorkflowList -> ContextItems -> IO ()
start wfName wfList ctxItems = let
    fullCtxItems = insert "WorkflowList" (WorkflowList wfList) ctxItems
    newContext = Context fullCtxItems Nothing
    in evalWF (exec wfName id) newContext 

exec :: String -> (Context -> Context) -> WF ()
exec wfName ctxModifier = do
    wf <- getWorkflow wfName
    wf

boot :: WorkflowName -> WorkflowList -> IO ()
boot startWF wfList = let
    initialContext = fromList [("FilePath", StringConst "/etc/xxx"), ("Logger", Logger putStrLn)]
    in start startWF wfList initialContext

-- My code


wf1 :: String -> WF ()
wf1 a = do
    log inf $ "Start workflow " ++ a
    exec a emptyContext
    log inf "Done."

wf2 :: WF ()
wf2 = do
    log inf "Here we go!"

wfList :: WorkflowList
wfList = fromList [("WF1", wf1 "WF2"), ("WF2", wf2)]
