{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}
import           Language.C.Inline

include "<math.h>"
include "<stdio.h>"

test_cexp :: Double -> Double -> IO Double
test_cexp x y =
  [cexp| double(double x, double y){ cos(x) + cos(y) } |]

test_cexp_unsafe :: Double -> Double -> IO Double
test_cexp_unsafe x y =
  [cexp_unsafe| double(double x, double y){ cos(x) + cos(y) } |]

test_cexp_pure :: Double -> Double
test_cexp_pure x =
  [cexp_pure| double(double x){ cos(x) + sin(x) } |]

test_cexp_pure_unsafe :: Double -> Double
test_cexp_pure_unsafe x =
  [cexp_pure_unsafe| double(double x){ cos(x) + sin(x) } |]

test_suffixType1 :: Int32 -> Int32 -> Int32
test_suffixType1 x _y = [cexp_pure| int{ $(int x) + $(int x) } |]

test_suffixType2 :: Int32 -> Int32 -> Int32
test_suffixType2 x y = [cexp_pure| int(){ $(int x) + $(int y) } |]

test_suffixType3 :: Int32 -> Int32 -> Int32
test_suffixType3 x y = [cexp_pure| int(int x){ x + $(int y) } |]

test_suffixType4 :: Int32 -> Int32 -> Int32
test_suffixType4 x y = [cexp_pure| int(int x){ $(int x) + $(int y) } |]

test_voidExp :: IO ()
test_voidExp = [cexp| void { printf("Hello\n") } |]

main :: IO ()
main = do
  print =<< test_cexp 3 4
  print =<< test_cexp_unsafe 3 4
  print $ test_cexp_pure 4
  print $ test_cexp_pure_unsafe 4
  print $ test_suffixType1 1 2
  print $ test_suffixType2 1 2
  print $ test_suffixType3 1 2
  print $ test_suffixType4 1 2
  test_voidExp
