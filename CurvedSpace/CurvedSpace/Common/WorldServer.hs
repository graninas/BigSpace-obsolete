module Common.WorldServer where


import qualified Data.ByteString.Char8 as B

import Network.Socket hiding (recv)
import Network.Socket.ByteString
import qualified Control.Concurrent as C

import Common.InteropTypes
import Common.World


startServer serverName (host, port) mvars = do
    putStr (serverName ++ " Starting...")
    sock <- socket AF_INET Stream defaultProtocol
    bindSocket sock (SockAddrInet (toEnum port) (fromInteger host))
    listen sock 1
    threadId <- C.forkOS $ acceptConnections serverName mvars sock
    putStrLn (" Done.")
    return threadId


-- | 
acceptConnections :: String -> InteropMsg -> Socket -> IO ()
acceptConnections serverName mvars@(gameMVar, worldMVar) sock = do
    (conn, _) <- accept sock
    res <- recv conn 4096
    sClose conn
    B.putStr . B.pack $ (serverName ++ " Received: ")
    B.putStrLn res
    case reverse . take 4 . reverse . B.unpack $ res of
        "exit" -> do
            putStrLn (serverName ++ " Stopping game cycle...")
            C.putMVar worldMVar "exit"
            putStr (serverName ++ " Stopping self...")
            sClose sock
            putStrLn " Done."
        _ -> acceptConnections serverName mvars sock