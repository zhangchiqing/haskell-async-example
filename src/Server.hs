module Server where

import Control.Concurrent (threadDelay)
import Network.HTTP.Types.Status (status200)
import qualified Web.Scotty as S

start :: IO ()
start =
  S.scotty 7788 $ do
    S.get "/getA" $ do
      S.liftAndCatchIO $ threadDelay 2000000
      S.status status200
    S.get "/getB" $ do
      S.liftAndCatchIO $ threadDelay 1000000
      S.status status200
    S.get "/getC" $ do
      S.liftAndCatchIO $ threadDelay 1000000
      S.status status200
    S.get "/getD" $ do
      S.liftAndCatchIO $ threadDelay 3000000
      S.status status200
    S.get "/getE" $ do
      S.liftAndCatchIO $ threadDelay 2000000
      S.status status200
