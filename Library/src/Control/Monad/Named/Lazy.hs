-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Monad.Named.Lazy
-- Copyright   :  (c) Alexander Granin
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  graninas@gmail.com
-- Stability   :  experimental
-- Portability :  non-portable (multi-param classes, functional dependencies)
--
-- Lazy named monads (laziness is experimental - not tested yet).
--
-----------------------------------------------------------------------------

module Control.Monad.Named.Lazy (
    -- * MonadNamed class
    MonadNamed(..),
    -- * The Named monad
    Named,
    runNamed,
    -- * The NamedT transformer
    NamedT(..),
    -- * Named monad operations
    withName,
    evalNamedT,
    module Control.Monad,
    module Control.Monad.Fix,
    module Control.Monad.Trans
    -- * Examles
    -- $examples
  ) where

import Control.Monad.Named.Class
import Control.Monad.Trans.Named.Lazy (
    Named, runNamed, evalNamedT, withName, NamedT(..),
    named, getName)

import Control.Monad
import Control.Monad.Trans
import Control.Monad.Fix

------------------------------------------------------------------
-- $examples
-- Int-named IO calculations:
-- > testIntNamed :: IO ()
-- > testIntNamed = do
-- >     res <- evalNamedT intNamedFunc 1
-- >     putStrLn . show $ res  -- Output: 1

-- > intNamedFunc :: NamedT Int IO Int
-- > intNamedFunc = do
-- >     name <- getName
-- >     return name

-- String-named IO calculations:
-- > testStringNamed :: IO ()
-- > testStringNamed = do
-- >     res <- evalNamedT outerStringNamedFunc "Outer"
-- >     putStrLn . show $ res  -- Output: ["Outer", "Outer", "Inner", "Outer"]

-- > outerStringNamedFunc :: NamedT String IO [String]
-- > outerStringNamedFunc = do
-- >     outerName1 <- getName
-- >     innerName1 <- innerStringNamedFunc
-- >     innerName2 <- withName innerStringNamedFunc "Inner"
-- >     outerName2 <- getName
-- >     return $ outerName1 : innerName1 : innerName2 : outerName2 : []

-- > innerStringNamedFunc :: NamedT String IO String
-- > innerStringNamedFunc = getName >>= return
