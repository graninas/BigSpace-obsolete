module Game.Wires where

import Graphics.UI.SDL
import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Events
import Graphics.UI.SDL.TTF.Management
import Graphics.UI.SDL.TTF.Render


import Utils.Colors

import Wire.Wire

pollEventWire = makeWire $ do
    e <- pollEvent
    return (Right e)


applySurface :: Int -> Int -> Surface -> Surface -> Maybe Rect -> IO Bool
applySurface x y src dst clip = blitSurface src clip dst offset
    where offset = Just Rect { rectX = x, rectY = y, rectW = 0, rectH = 0 }


mainMenuWire = makeWire $ do
        videoSurface <- getVideoSurface
        
        font <- openFont "lazy.ttf" 28
        message <- renderTextSolid font "Quit" activeMenuColor
        
        applySurface 0 100 message videoSurface Nothing
        Graphics.UI.SDL.flip videoSurface 

        return (Right NoEvent)
    
    