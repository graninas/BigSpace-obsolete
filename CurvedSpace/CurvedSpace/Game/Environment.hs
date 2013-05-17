module Game.Environment where

import Graphics.UI.SDL


runEnvironment scrWidth scrHeight scrBpp cont = withInit [InitEverything] $ do
    screen <- setVideoMode scrWidth scrHeight scrBpp [SWSurface]
    setCaption "CurvedSpace" []
    
    Graphics.UI.SDL.flip screen
    
    cont