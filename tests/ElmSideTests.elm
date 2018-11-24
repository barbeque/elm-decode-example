module ElmSideTests exposing (..)

import ElmSide exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Dict exposing (..)
import Json.Encode exposing (..)


suite : Test
suite =
    describe "Basic JSON decoding"
      [ test "Can decode singleton dict" <|
        \_ ->
          let
            dict = Dict.singleton "Betsy" "cow"
            encoded = Json.Encode.dict identity Json.Encode.string dict
            decoded = ElmSide.decodeDict encoded
          in
            getAnimalSpecies "Betsy" decoded
              |> Expect.equal "cow"
      ]
