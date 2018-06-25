module Client where

import Control.Concurrent.Async (async, wait)
import Control.Monad (join)
import Control.Monad (void)
import Data.Time (getCurrentTime)
import qualified Network.Wreq as W

serverHost :: String
serverHost = "http://localhost:7788"

timeit :: String -> IO a -> IO a
timeit msg io = do
  getCurrentTime >>= print . append start
  a <- io
  getCurrentTime >>= print . append finished
  return a
  where
    start = " " ++ msg ++ " started"
    finished = " " ++ msg ++ " finished"
    append msg time = show time ++ msg

getA :: IO String
getA = timeit "getA" $ fmap (const "A") $ W.get $ serverHost ++ "/getA"

getB :: IO String
getB = timeit "getB" $ fmap (const "B") $ W.get $ serverHost ++ "/getB"

getC :: String -> String -> IO String
getC _ _ = timeit "getC" $ fmap (const "C") $ W.get $ serverHost ++ "/getC"

getD :: String -> IO String
getD _ = timeit "getD" $ fmap (const "D") $ W.get $ serverHost ++ "/getD"

getE :: String -> String -> IO String
getE _ _ = timeit "getE" $ fmap (const "E") $ W.get $ serverHost ++ "/getE"

getAllSync :: IO String
getAllSync = do
  a <- getA -- 2
  b <- getB --  1
  c <- getC a b -- 1
  d <- getD b -- 3
  e <- getE c d -- 2
  return e

getAll :: IO String
getAll = do
  aP <- async getA
  bP <- async getB
  cP <- async $ join $ getC <$> wait aP <*> wait bP
  dP <- async $ join $ getD <$> wait bP
  join $ getE <$> wait cP <*> wait dP
