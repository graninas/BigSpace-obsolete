module Common.Trash.CurvedSpaceTrash where

import qualified Control.Concurrent.MVar as M (tryTakeMVar, tryPutMVar, newEmptyMVar, newMVar, MVar) 
import qualified Control.Concurrent as C
import qualified Graphics.UI.GLUT as GLUT
import qualified Control.Monad.State as State
import Control.Monad (when)
import Data.Maybe (isJust, fromJust)

import Common.Types
import Common.InteropTypes
import Common.GLTypes
import Common.GL
import Common.Constants
import Common.TickTime
import Draw.Draw

import Common.World

     
data GameWorld = GameWorld
     { gwObjectVelocity :: (Word, Word, Word)
     }
  deriving (Show, Eq)

type GW a = State.StateT GameWorld IO a




    gameMVar <- M.newEmptyMVar
    worldMVar <- M.newEmptyMVar
    let mvars = (gameMVar, worldMVar)

    wnd <- initializeGLWindow drawScene

-- Main game loop
    currentTime <- getIOTickTime
    let nextTactTime = addTickTime tactsFrequency currentTime
    let startGameTact = GameTact 0 currentTime 0 0 currentTime nextTactTime 60.0
    
    let gw = GameWorld (10, 4, 6)
    let gameLoopF = gameLoop wnd mvars startGameTact
    gameThreadId <- C.forkOS (gameThreadFunc gameLoopF gw)

    startGlutLoop
--    C.killThread gameThreadId
    putStrLn "Ok."



-- | Runs game thread function. Currently it is gameLoop in State monad with IO.
gameThreadFunc :: GW () -> GameWorld -> IO ()
gameThreadFunc = State.evalStateT

-- | Prints fps in console.
showFps :: Float -> GW ()
showFps fps = State.liftIO . putStrLn $ ("FPS: " ++ show fps)

-- | Prints information about elapsed time since previous frame.
showElapsed :: Elapsed -> GW ()
showElapsed (Elapsed ticks prevTime curTime elapsedTime) = State.liftIO $
    putStrLn ("Ticks: " ++ show ticks ++ " PrevTime: " ++ show prevTime
    ++ " CurTime: " ++ show curTime ++ " ElapsedTime: " ++ show elapsedTime)

-- Redraws GL window and puts message about frame to console.
redrawFrame :: GLUT.Window -> GW ()
redrawFrame wnd = State.liftIO . redrawGLWindow $ wnd

recalculateWorld :: Elapsed -> GW ()
recalculateWorld (Elapsed _ _ _ elapsedTime) = do
    gw@(GameWorld (vx, vy, vz)) <- State.get
    State.liftIO . putStrLn $ ("ObjVel: \n" ++ show vx ++ "\n" ++ show vy ++ "\n" ++ show vz)
    

-- | Main game loop. Processes incoming MVar (worldVar) and sends outcoming MVar (gameMVar).
gameLoop :: GLUT.Window -> InteropMsg -> GameTact -> GW ()
gameLoop wnd mvars@(gameMVar, worldMVar) gameTact = do

    curTickTime <- State.liftIO getIOTickTime
    let (isNewFrame, elapsed, newGameTact) = evalGameTact fpsSettings gameTact curTickTime
    
    when isNewFrame (showFps (gtFps newGameTact) >> recalculateWorld elapsed >> redrawFrame wnd)
    
    gameLoop wnd mvars newGameTact


    