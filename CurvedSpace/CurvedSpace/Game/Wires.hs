module Game.Wires where

import Graphics.UI.SDL
import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Events
import Control.Wire
import Prelude hiding ((.), id)

import Wire.Wire
import Utils.Constants
import SDL.Helpers
import SDL.Keys


makeWire io = mkFixM $ \_ _ -> io 


pollEventWire = makeWire $ do
    e <- pollEvent
    return (Right e)


gameWire = drawMenuWire
{-
    accum (\menu func -> func menu) mainMenu
    . (   pure toPrev . when isUpKey
      <|> pure toNext . when isDownKey
      )
    . pollEventWire
-}



drawMenuWire =
    drawMenuItemWire
    . list (zip coords mainMenuItems)
  where
    coords = (verticalCoordsStrip (0, 100) menuItemDY)

drawMenuItemWire :: Wire () IO (Pos2D, MenuItem) ()
drawMenuItemWire = mkFixM $ \_ ((x, y), (name, _)) -> do 
    drawText x y textSize activeMenuColor name
    return (Right ())




verticalCoordsStrip :: Pos2D -> Int -> [Pos2D]
verticalCoordsStrip (startX, startY) dy = [(startX, y) | y <- [startY, startY + dy..]]

type Pos2D = (Int, Int)
type MenuItem = (String, Int)
data Menu = Menu Int [MenuItem]
toPrev, toNext :: Menu -> Menu
toPrev (Menu selected items) | selected == 1 = (Menu (length items) items)
                             | otherwise = Menu (selected - 1) items
toNext (Menu selected items) | selected == length items = Menu 1 items
                             | otherwise = Menu (selected + 1) items
                             
mainMenu :: Menu
mainMenu = Menu 1 mainMenuItems
mainMenuItems :: [MenuItem]
mainMenuItems = [ ("New world!", 1)
                , ("Quit", 2) ]
    
    