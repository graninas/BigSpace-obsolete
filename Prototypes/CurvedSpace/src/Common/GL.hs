module Common.GL (initialize, redrawWindow) where

import Graphics.Rendering.OpenGL
import qualified Graphics.Rendering.OpenGL.Raw as GLRaw
import qualified Graphics.Rendering.GLU.Raw as GLURaw (gluPerspective)
import qualified Graphics.UI.GLUT as GLUT

import qualified Control.Concurrent.MVar as M (tryTakeMVar, tryPutMVar, MVar) 

import Common.GLTypes

initialize :: IO () -> IO GLUT.Window
initialize drawFunc = do
    (progName, _) <- GLUT.getArgsAndInitialize
    wnd <- GLUT.createWindow progName
    GLUT.initialDisplayMode GLUT.$= [GLUT.RGBAMode, GLUT.WithDepthBuffer, GLUT.DoubleBuffered]
    
    GLUT.displayCallback GLUT.$= (displayCallback drawFunc)
    GLUT.reshapeCallback GLUT.$= Just reshapeCallback
    
    GLRaw.glShadeModel GLRaw.gl_SMOOTH
    GLRaw.glClearColor 0 0 0 0
    GLRaw.glClearDepth 1
    GLRaw.glEnable GLRaw.gl_DEPTH_TEST
    GLRaw.glDepthFunc GLRaw.gl_LEQUAL
    GLRaw.glHint GLRaw.gl_PERSPECTIVE_CORRECTION_HINT GLRaw.gl_NICEST
    GLRaw.glEnable GLRaw.gl_TEXTURE_2D
    
    return wnd
    
redrawWindow :: GLUT.Window -> IO ()
redrawWindow wnd = GLUT.postRedisplay (Just wnd)


displayCallback :: IO () -> IO ()
displayCallback drawFunc = do
     drawFunc
     GLUT.swapBuffers

reshapeCallback (GLUT.Size w 0) = reshapeCallback (GLUT.Size w 1)
reshapeCallback (GLUT.Size width height) = do
    GLRaw.glViewport 0 0 (fromIntegral width) (fromIntegral height)
    GLRaw.glMatrixMode GLRaw.gl_PROJECTION
    GLRaw.glLoadIdentity
    GLURaw.gluPerspective 45 (fromIntegral width/fromIntegral height) 0.1 100
    GLRaw.glMatrixMode GLRaw.gl_MODELVIEW
    GLRaw.glLoadIdentity
    GLUT.swapBuffers


