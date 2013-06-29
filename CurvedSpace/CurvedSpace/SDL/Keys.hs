module SDL.Keys where

import Graphics.UI.SDL

import qualified Data.Map as Map
import qualified Data.Char as C

extractChar :: SDLKey -> Map.Map SDLKey Char -> Maybe Char
extractChar = Map.lookup

isUpKey (KeyDown (Keysym key _ _)) = key == SDLK_UP
isUpKey _ = False

isDownKey (KeyDown (Keysym key _ _)) = key == SDLK_DOWN
isDownKey _ = False

isLetter l (KeyDown (Keysym key _ _)) =
    Map.member (C.toLower l) lettersSdl

sdlDigits, sdlLetters :: Map.Map SDLKey Char
sdlDigits = Map.fromList sdlDigitsAssoc
sdlLetters = Map.fromList sdlLettersAssoc

digitsSdl, lettersSdl :: Map.Map Char SDLKey
digitsSdl = Map.fromList digitsSdlAssoc
lettersSdl = Map.fromList lettersSdlAssoc

sdlDigitsAssoc = [ (SDLK_0, '0')     
            , (SDLK_1, '1')
            , (SDLK_2, '2')
            , (SDLK_3, '3')
            , (SDLK_4, '4')
            , (SDLK_5, '5')
            , (SDLK_6, '6')
            , (SDLK_7, '7')
            , (SDLK_8, '8')
            , (SDLK_9, '9')
           ]
digitsSdlAssoc = map reversePair sdlDigitsAssoc

sdlLettersAssoc = 
            [ (SDLK_a, 'a')
            , (SDLK_b, 'b')
            , (SDLK_c, 'c')
            , (SDLK_d, 'd')
            , (SDLK_e, 'e')
            , (SDLK_f, 'f')
            , (SDLK_g, 'g')
            , (SDLK_h, 'h')
            , (SDLK_i, 'i')
            , (SDLK_j, 'j')
            , (SDLK_k, 'k')
            , (SDLK_l, 'l')
            , (SDLK_m, 'm')
            , (SDLK_n, 'n')
            , (SDLK_o, 'o')
            , (SDLK_p, 'p')
            , (SDLK_q, 'q')
            , (SDLK_r, 'r')
            , (SDLK_s, 's')
            , (SDLK_t, 't')
            , (SDLK_u, 'u')
            , (SDLK_v, 'v')
            , (SDLK_w, 'w')
            , (SDLK_x, 'x')
            , (SDLK_y, 'y')
            , (SDLK_z, 'z')
            ]
lettersSdlAssoc = map reversePair sdlLettersAssoc

reversePair = \(a, b) -> (b, a)