module Explanation.Model exposing (..)

import Card exposing (Card(..))
import Process
import Random
import Task


initial handCards seedInt =
    let
        ( command, steppedSeed ) =
            initialCommand seedInt <| List.length handCards
    in
    ( { hand =
            { cards = handCards
            , animation = NoHandAnimation
            }
      , maxHandSize = List.length handCards
      , placed =
            { animation = NoPlacedAnimation
            , maybeCard = Nothing
            }
      , seed = Random.initialSeed seedInt
      }
    , command
    )


initialCommand seedInt handSize =
    let
        ( cardIndex, steppedSeed ) =
            Random.step (Random.int 0 <| handSize - 1) <| Random.initialSeed seedInt
    in
    ( Task.perform (\_ -> PlaceCard cardIndex) (Process.sleep 1250), steppedSeed )


type alias Model =
    { hand :
        { animation : HandAnimation
        , cards : List Card
        }
    , maxHandSize : Int
    , placed :
        { animation : PlacedAnimation
        , maybeCard : Maybe Card
        }
    , seed : Random.Seed
    }


type HandAnimation
    = PlaceHandCard HandIndex
    | NoHandAnimation


type PlacedAnimation
    = DuplicateAtPlaced Card
    | ReturnPlacedCardToHand
    | NoPlacedAnimation


type alias HandIndex =
    Int


type alias ReturnedPlacedCard =
    Maybe Card


type alias CardFromHand =
    Card


type Msg
    = PlaceCard HandIndex
    | Rearrange CardFromHand ReturnedPlacedCard HandIndex
