-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Monad.Trans.Named
-- Copyright   :  (c) Alexander Granin
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  graninas@gmail.com
-- Stability   :  experimental
-- Portability :  portable
--
-- Lazy named monads, passing an immutable name through a computation.
-- See below for examples.
--
-- Laziness is experimenal now, not tested yet.
--
-- For state computations, see "Control.Monad.Trans.State".
-----------------------------------------------------------------------------

module Control.Monad.Trans.Named (
    module Control.Monad.Trans.Named.Lazy
    ) where

import Control.Monad.Trans.Named.Lazy