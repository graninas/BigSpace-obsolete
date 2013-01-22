module Main where

import Network.Socket hiding (recv)
import Network.Socket.ByteString
import qualified Data.ByteString.Char8 as B
import qualified Control.Concurrent.MVar as M (tryTakeMVar, tryPutMVar, newEmptyMVar, MVar) 
import qualified Control.Concurrent as C
import Control.Monad (when)
import qualified System.Time as T
import qualified Graphics.UI.GLUT as GLUT

import qualified Common.GLTypes as GLTypes
import qualified Common.GL as GL
import qualified Common.Constants as Constants 
import qualified Common.InteropTypes as Interop

import qualified Draw.Draw as Draw

main::IO ()
main = do 
-- Socket Network Server
--    putStrLn "Starting server..."
--    sock <- socket AF_INET Stream defaultProtocol
--    bindSocket sock (SockAddrInet 4343 0)
--    listen sock 1
--    socketServerThread <- C.forkOS $ acceptConnections mVar sock

    wnd <- GL.initialize Draw.draw

-- Main game loop
    gameCycleStatsMVar <- M.newEmptyMVar
    currentTime <- T.getClockTime
    let startTime = T.addToClockTime Constants.framesFrequency currentTime
    gameThreadId <- C.forkOS $ gameLoop wnd gameCycleStatsMVar 0 startTime

    GLUT.mainLoop

--    C.killThread socketServerThread
--    C.killThread gameThreadId
    putStrLn "Ok."
    

acceptConnections :: M.MVar B.ByteString -> Socket -> IO ()
acceptConnections mVar sock = do
    (conn, _) <- accept sock
    res <- recv conn 4096
    sClose conn
    B.putStr . B.pack $ "Received: "
    B.putStrLn res
    M.tryPutMVar mVar res
    case reverse . take 4 . reverse . B.unpack $ res of
        "exit" -> do
            putStrLn "Stopping server..."
            sClose sock
        _ -> acceptConnections mVar sock


gameLoop :: GLUT.Window -> Interop.GameCycleStats -> Float -> T.ClockTime -> IO () 
gameLoop wnd gameCycleStatsMVar iteration nextFrameTime = do
    curClockTime <- T.getClockTime
    
    M.tryPutMVar gameCycleStatsMVar ((iteration, curClockTime), Nothing)
    
    when (curClockTime >= nextFrameTime) (do
        let newNextFrameTime = T.addToClockTime Constants.framesFrequency nextFrameTime
        let newIteration = iteration + 1
        putStr ("Iteration: " ++ show newIteration)
        GL.redrawWindow wnd
        putStrLn ". Drawn."
        gameLoop wnd gameCycleStatsMVar newIteration newNextFrameTime)
    
    gameLoop wnd gameCycleStatsMVar iteration nextFrameTime
    
    