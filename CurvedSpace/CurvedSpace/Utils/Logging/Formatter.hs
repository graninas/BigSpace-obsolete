module Utils.Logging.Format where

import Text.Printf

type Formatter = String -> String -> String

err, inf :: Formatter
err t = printf "%s ERR %s" t
inf t = printf "%s INF %s" t
inf1 _ = printf "INF %s"