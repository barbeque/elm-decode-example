module ElmSide exposing (..)

import Browser exposing (element)
import Html exposing (..)
import Dict exposing (..)
import Json.Decode exposing (..)

-- Stuff passed from JS.
type alias Flags =
  { nameToSpecies: Json.Decode.Value
  }

-- Runtime state.
type alias Model =
  { nameToSpecies: (Dict String String)
  }

type Msg = Pet

getAnimalSpecies: String -> (Dict String String) -> String
getAnimalSpecies name nameToSpecies =
  -- simple dictionary lookup, but it can fail
  case Dict.get name nameToSpecies of
    Just petSpecies -> petSpecies
    _ -> "Could not find a pet named " ++ name

{-| Decode the JSON object passed in from the HTML page's flags
into an Elm dictionary that we can use -}
decodeDict : Json.Decode.Value -> (Dict String String)
decodeDict jsonSpeciesDict =
  let
    -- build a decoder
    jsonToDictDecoder = Json.Decode.dict (string)
  in
    -- use the decoder on the object passed in by flags
    case decodeValue jsonToDictDecoder jsonSpeciesDict of
      Ok dict -> dict
      Err message -> Dict.fromList [] -- don't have a better thing to do here.

init : Flags -> ( Model, Cmd Msg )
init flags =
  let
    decodedSpeciesDict = decodeDict flags.nameToSpecies
  in
    ( { nameToSpecies = decodedSpeciesDict }, Cmd.none )

view : Model -> Html Msg
view model =
  let
    petSpecies = getAnimalSpecies "Colby" model.nameToSpecies
  in
    div []
      [ text ( "Colby is a " ++ petSpecies )]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ( model, Cmd.none ) -- do nothing

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main =
  Browser.element
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view}
