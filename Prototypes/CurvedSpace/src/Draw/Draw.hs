module Draw.Draw where

import qualified Graphics.Rendering.OpenGL as GL

import Common.Units
import Common.GLTypes


draw :: IO ()
draw = do
    GL.clear [GL.ColorBuffer, GL.DepthBuffer]
    GL.loadIdentity
    