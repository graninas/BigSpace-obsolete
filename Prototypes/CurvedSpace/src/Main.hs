module Main where

import Network.Socket hiding (recv)
import Network.Socket.ByteString
import qualified Data.ByteString.Char8 as B
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
import Draw.Draw

main::IO ()
main = do

    gameMVar <- M.newEmptyMVar
    worldMVar <- M.newEmptyMVar
    let mvars = (gameMVar, worldMVar)

-- Socket Network Server
    putStrLn "Starting [WorldServer]..."
    sock <- socket AF_INET Stream defaultProtocol
    bindSocket sock (SockAddrInet 4343 0)
    listen sock 1
    socketServerThread <- C.forkOS $ acceptConnections mvars sock

    wnd <- initializeGLWindow drawScene

-- Main game loop
    currentTime <- T.getClockTime
    let startFrameInfo = (0, T.addToClockTime framesFrequency currentTime)
    gameThreadId <- C.forkOS $ gameLoop wnd mvars startFrameInfo

    startGlutLoop

--    C.killThread socketServerThread
--    C.killThread gameThreadId
    putStrLn "Ok."


worldServerName = "[WorldServer]"
gameLoopName = "[GameLoop]"

acceptConnections ::
    InteropMsg
    -> Socket
    -> IO ()
acceptConnections mvars@(gameMVar, worldMVar) sock = do
    (conn, _) <- accept sock
    res <- recv conn 4096
    sClose conn
    B.putStr . B.pack $ (worldServerName ++ " Received: ")
    B.putStrLn res
    case reverse . take 4 . reverse . B.unpack $ res of
        "exit" -> do
            putStrLn (worldServerName ++ " Stopping game cycle...")
            C.putMVar worldMVar "exit"
            putStr (worldServerName ++ " Stopping self...")
            sClose sock
            putStrLn " Done."
        _ -> acceptConnections mvars sock


processMessage :: Maybe String -> FrameInfo -> IO (Bool, FrameInfo)
processMessage Nothing        frameInfo = return (False, frameInfo)
processMessage (Just "exit")  frameInfo = putStrLn (gameLoopName ++ " Finish message received.") >> return (True, frameInfo)
processMessage (Just unknown) frameInfo = putStrLn (gameLoopName ++ " Unknown message: " ++ unknown) >> return (True, frameInfo) 

redraw :: GLUT.Window -> InteropMsg -> FrameInfo -> IO (Bool, FrameInfo)
redraw wnd mvars (iter, nextFrameTime) = do
        let newNextFrameTime = T.addToClockTime framesFrequency nextFrameTime
        let newIter = iter + 1
        putStr (gameLoopName ++ " Iteration: " ++ show newIter)
        redrawGLWindow wnd
        putStrLn ". Drawn."
        return (False, (newIter, newNextFrameTime))


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
gameLoop :: 
    GLUT.Window
    -> InteropMsg
    -> FrameInfo
    -> IO ()
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
    
    