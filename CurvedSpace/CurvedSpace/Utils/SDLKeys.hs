module Utils.SDLKeys where

import Graphics.UI.SDL

import qualified Data.Map as Map

translateChar :: SDLKey -> Maybe Char
translateChar key = Map.lookup key letterKeys

letterKeys = Map.fromList
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

