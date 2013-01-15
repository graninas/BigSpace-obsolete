module Draw.Draw where

import qualified Graphics.Rendering.OpenGL as GL

import Draw.TextureInit
import Common.Units
import Common.GLTypes


draw :: DrawFunction
draw ress@(GLResources texRes) n = do
    putStr $ "Current n = " ++ show n
    GL.clear [GL.ColorBuffer, GL.DepthBuffer]
    GL.loadIdentity

    putStrLn " Ok."
    
    
    
    