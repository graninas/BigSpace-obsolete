{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies #-}

module Trash.Crib.MonadNamed where

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

getName = named (\name -> name)

{-
class (Monad m) => MonadNamed n m | m -> n where
    getName :: (Monad m) => m n
    getName = named (\name -> name)
-}


withName :: (Monad m, MonadTrans t) => NamedT n m a -> n -> t m a
withName f name = lift (evalNamedT f name)

evalNamedT :: (Monad m) => NamedT n m a -> n -> m a
evalNamedT nt name = do
    a <- runNamedT nt name
    return a

-- Examples

-- Int-named IO calculations:
testIntNamed :: IO ()
testIntNamed = do
    res <- evalNamedT intNamedFunc 1
    putStrLn . show $ res

intNamedFunc :: NamedT Int IO Int
intNamedFunc = do
    name <- getName
    return name

-- Output: 1

-- String-named IO calculations:
testStringNamed :: IO ()
testStringNamed = do
    res <- evalNamedT outerStringNamedFunc "Outer"
    putStrLn . show $ res

-- Output: ["Outer", "Outer", "Inner", "Outer"]

outerStringNamedFunc :: NamedT String IO [String]
outerStringNamedFunc = do
    outerName1 <- getName
    innerName1 <- innerStringNamedFunc
    innerName2 <- withName innerStringNamedFunc "Inner"
    outerName2 <- getName
    return $ outerName1 : innerName1 : innerName2 : outerName2 : []

innerStringNamedFunc :: NamedT String IO String
innerStringNamedFunc = getName >>= return
    