{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, FunctionalDependencies #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Monad.Named.Class
-- Copyright   :  (c) Alexander Granin 2013
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  graninas@gmail.com
-- Stability   :  experimental
-- Portability :  non-portable (multi-param classes, functional dependencies)
--
-- Named computations.
-----------------------------------------------------------------------------

module Control.Monad.Named.Class (
    MonadNamed(..)
    ) where


import qualified Control.Monad.Trans.Named.Lazy as Lazy

class (Monad m) => MonadNamed n m | m -> n where
    getName :: (Monad m) => m n
    getName = named (\name -> name)
    
    named :: (n -> a) -> m a
    named f = do
        n <- getName
        let a = f n
        return a
        
instance Monad m => MonadNamed n (Lazy.NamedT n m) where
    getName = Lazy.getName
    named = Lazy.named
    
    
    
