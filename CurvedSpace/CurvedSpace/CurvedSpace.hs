module Main where

import qualified Control.Concurrent.MVar as M (tryTakeMVar, tryPutMVar, newEmptyMVar, newMVar, MVar) 
import qualified Control.Concurrent as C
import Control.Monad (when)
import Data.Maybe (isJust, fromJust)
import qualified System.Time as T
import qualified Graphics.UI.GLUT as GLUT


import Common.Types
import Common.InteropTypes
import Common.GLTypes
import Common.GL
import Common.Constants
import Common.WorldServer
import Draw.Draw

import Common.World

worldServerName = "[WorldServer]"
gameLoopName = "[GameLoop]"

main::IO ()
main = do

    gameMVar <- M.newEmptyMVar
    worldMVar <- M.newEmptyMVar
    let mvars = (gameMVar, worldMVar)

-- Socket Network Server
    serverTreadId <- startServer worldServerName serverAddress mvars

    wnd <- initializeGLWindow drawScene

-- Main game loop
    currentTime <- T.getClockTime
    let startFrameInfo = (0, T.addToClockTime framesFrequency currentTime)
    gameThreadId <- C.forkOS $ gameLoop wnd mvars startFrameInfo

    startGlutLoop

--    C.killThread socketServerThread
--    C.killThread gameThreadId
    putStrLn "Ok."





-- | Processes incoming message.
processMessage :: Maybe String -> FrameInfo -> IO (Bool, FrameInfo)
processMessage Nothing        frameInfo = return (False, frameInfo)
processMessage (Just "exit")  frameInfo = putStrLn (gameLoopName ++ " Finish message received.") >> return (True, frameInfo)
processMessage (Just unknown) frameInfo = putStrLn (gameLoopName ++ " Unknown message: " ++ unknown) >> return (True, frameInfo) 

-- | Redraws GL window and puts message about frame to console.
redraw :: GLUT.Window -> InteropMsg -> FrameInfo -> IO (Bool, FrameInfo)
redraw wnd mvars (iter, nextFrameTime) = do
        let newNextFrameTime = T.addToClockTime framesFrequency nextFrameTime
        let newIter = iter + 1
        putStr (gameLoopName ++ " Iteration: " ++ show newIter)
        redrawGLWindow wnd
        putStrLn ". Drawn."
        return (False, (newIter, newNextFrameTime))


-- | Evaluate game loop operations.
-- | Operation have type (Bool, IO ()) where Bool - is flag indicating
-- | if operation should be evaluated.
-- | If operation returns (True, _) then game cycle should be stopped.
evalOperations :: FrameInfo -> [(Bool, IO (Bool, FrameInfo))] -> IO (Bool, FrameInfo)
evalOperations defaultFrameInfo [] = return (False, defaultFrameInfo)
evalOperations defaultFrameInfo ( (evaluable, op) : ops) = 
    case evaluable of
        True -> do
                (stopEvaluation, frameInfo) <- op
                if stopEvaluation
                    then return (True, frameInfo)
                    else evalOperations frameInfo ops
        False -> evalOperations defaultFrameInfo ops  


-- | Main game loop. Processes incoming MVar (worldVar) and sends outcoming MVar (gameMVar).
gameLoop :: GLUT.Window -> InteropMsg -> FrameInfo -> IO ()
gameLoop wnd mvars@(gameMVar, worldMVar) frameInfo@(iter, nextFrameTime) = do
    curClockTime <- T.getClockTime
    
    C.tryPutMVar gameMVar ((iter, curClockTime), "")
    maybeWorldServerMessage <- C.tryTakeMVar worldMVar
    
    let operations = [ ((isJust maybeWorldServerMessage), processMessage maybeWorldServerMessage (iter, curClockTime))
                     , ((curClockTime >= nextFrameTime),  redraw wnd mvars (iter, nextFrameTime)) ]
        
    (done, newFrameInfo) <- evalOperations frameInfo operations
    case done of
        True ->  putStrLn (gameLoopName ++ " Done.")
        False -> gameLoop wnd mvars newFrameInfo
    
    