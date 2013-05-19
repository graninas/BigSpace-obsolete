module SDL.Helpers where

import Prelude hiding (flip)
import Graphics.UI.SDL
import Graphics.UI.SDL.Video
import Graphics.UI.SDL.TTF.Management
import Graphics.UI.SDL.TTF.Render
import Control.Exception (bracket)

import Utils.Constants

applySurface :: Int -> Int -> Surface -> Surface -> Maybe Rect -> IO Bool
applySurface x y src dst clip = blitSurface src clip dst offset
    where offset = Just $ Rect x y 0 0

apply x y srcSurface clip dstSurface = applySurface x y srcSurface dstSurface clip
    
withVideoSurface action = bracket getVideoSurface flip action
withFont font size action = bracket (openFont font size) return action

drawText x y size color text = do
    message <- withFont defaultFont size $ (\font -> renderTextSolid font text color)
    withVideoSurface $ apply x y message Nothing
    
drawText' x y size color text = do
    videoSurface <- getVideoSurface
    font <- openFont defaultFont size
    message <- renderTextSolid font text color
    applySurface x y message videoSurface Nothing
    Graphics.UI.SDL.flip videoSurface
