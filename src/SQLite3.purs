module SQLite3 where

import Prelude

import Data.Function.Uncurried as FU
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Foreign (Foreign)

type FilePath = String
type Query = String
type Param = String

foreign import data DBConnection :: Type

foreign import _newDB ::
  FU.Fn2
    FilePath
    (DBConnection -> Effect Unit)
    (Effect Unit)
foreign import _closeDB ::
  FU.Fn2
    DBConnection
    (Unit -> Effect Unit)
    (Effect Unit)
foreign import _queryDB ::
  FU.Fn4
    DBConnection
    Query
    (Array Param)
    (Foreign -> Effect Unit)
    (Effect Unit)

newDB :: FilePath -> Aff DBConnection
newDB path =
  makeAff \cb -> mempty <$ FU.runFn2 _newDB path (cb <<< pure)
closeDB :: DBConnection -> Aff Unit
closeDB conn =
  makeAff \cb -> mempty <$ FU.runFn2 _closeDB conn (cb <<< pure)
queryDB :: DBConnection -> Query -> Array Param -> Aff Foreign
queryDB conn query params =
  makeAff \cb -> mempty <$ FU.runFn4 _queryDB conn query params (cb <<< pure)
