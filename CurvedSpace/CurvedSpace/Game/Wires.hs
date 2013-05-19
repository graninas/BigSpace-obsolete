module Game.Wires where

import Graphics.UI.SDL
import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Events
import Control.Wire
import qualified Control.Monad as M
import Prelude hiding ((.), id)

import Wire.Wire
import Utils.Constants
import SDL.Helpers
import SDL.Keys


makeWire io = mkFixM $ \_ _ -> io 


pollEventWire = makeWire $ do
    e <- pollEvent
    return (Right e)


gameWire = drawMenuWire mainMenu
{-
    accum (\menu func -> func menu) mainMenu
    . (   pure toPrev . when isUpKey
      <|> pure toNext . when isDownKey
      )
    . pollEventWire
-}



drawMenuWire (Menu selected items) =
    (   drawActiveMenuItemWire   . when (\(_, item) -> getIndex item == selected)
    <|> drawInactiveMenuItemWire . when (\(_, item) -> getIndex item /= selected)
    )
    . list (zip coords items)
  where
    coords = (verticalCoordsStrip (0, 100) menuItemDY)

drawActiveMenuItemWire, drawInactiveMenuItemWire :: Wire () IO (Pos2D, MenuItem) ()
drawActiveMenuItemWire = mkFixM $ \_ -> drawMenuItem activeMenuColor
drawInactiveMenuItemWire = mkFixM $ \_ -> drawMenuItem inactiveMenuColor
    
drawMenuItem color ((x, y), MenuItem (itemIndex, name)) = do 
    drawText x y textSize color name
    return (Right ())
    
verticalCoordsStrip :: Pos2D -> Int -> [Pos2D]
verticalCoordsStrip (startX, startY) dy = [(startX, y) | y <- [startY, startY + dy..]]

type Pos2D = (Int, Int)
newtype MenuItem = MenuItem (Int, String)
data Menu = Menu Int [MenuItem]
toPrev, toNext :: Menu -> Menu
toPrev (Menu selected items) | selected == 1 = (Menu (length items) items)
                             | otherwise = Menu (selected - 1) items
toNext (Menu selected items) | selected == length items = Menu 1 items
                             | otherwise = Menu (selected + 1) items
                             
mainMenu :: Menu
mainMenu = Menu 0 mainMenuItems
mainMenuItems :: [MenuItem]
mainMenuItems = makeMenuItems [ "New world!"
                              , "Quit"
                              ]
  where
    makeMenuItems items = map MenuItem $ zip [0..] items
    
class Enumerated a where
    getIndex :: a -> Int
  
instance Enumerated MenuItem where
    getIndex (MenuItem (index, _)) = index
    