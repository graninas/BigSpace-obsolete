-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Monad.Trans.Named.Lazy
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

module Control.Monad.Trans.Named.Lazy (
    -- * The Named monad
    Named,
    runNamed,
    -- * The NamedT transformer
    NamedT(..),
    named,
    -- * Named monad operations
    withName,
    getName,
    evalNamedT
    ) where

import Data.Monoid
import Control.Monad.IO.Class
import Control.Monad
import Control.Monad.Trans

newtype Named n a = Named { runNamed :: (n -> a) }

instance Monad (Named n) where
    return x = Named $ \_ -> x
    x >>= f = Named $ \name -> let
        a = runNamed x name
        in runNamed (f a) name

instance (Show a, Monoid n) => Show (Named n a) where
    show x = show (runNamed x mempty)
    
newtype NamedT n m a = NamedT { runNamedT :: (n -> m a) }

instance (Monad m) => Monad (NamedT n m) where
    return x = NamedT $ \_ -> return x 
    x >>= f = NamedT $ \name -> do
        a <- runNamedT x name
        b <- runNamedT (f a) name
        return b

instance MonadTrans (NamedT s) where
    lift m = NamedT $ \name -> do
        a <- m
        return a
        
instance (MonadIO m) => MonadIO (NamedT s m) where
    liftIO = lift . liftIO

named :: Monad m => (n -> a) -> NamedT n m a
named f = NamedT $ \name ->
    let a = f name
    in return a

getName :: (Monad m) => NamedT n m n
getName = named (\name -> name)

withName :: (Monad m, MonadTrans t) => NamedT n m a -> n -> t m a
withName f name = lift (evalNamedT f name)

evalNamedT :: (Monad m) => NamedT n m a -> n -> m a
evalNamedT nt name = do
    a <- runNamedT nt name
    return a