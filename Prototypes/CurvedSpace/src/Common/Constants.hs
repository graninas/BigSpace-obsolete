module Common.Constants where

import qualified Common.GLTypes as GLTypes
import System.Time


fpsFrequency = System.Time.TimeDiff 0 0 0 0 0 0 50000000000


texturesPath    = "./Textures"

helloTex        = "hello.tga"
hazardStripeTex = "hazard_stripe.tga"
yellowBaseTex   = "yellow_base.tga"
arrowTex        = "arrow.tga"
equalSignTex    = "equal_sign.tga"

rawTextureData :: GLTypes.RawTextures
rawTextureData = [ (helloTex,        texturesPath ++ "/" ++ helloTex)
                 , (hazardStripeTex, texturesPath ++ "/" ++ hazardStripeTex)
                 , (arrowTex,        texturesPath ++ "/" ++ arrowTex)
                 , (equalSignTex,    texturesPath ++ "/" ++ equalSignTex)
                 , (yellowBaseTex,   texturesPath ++ "/" ++ yellowBaseTex)
                 ]