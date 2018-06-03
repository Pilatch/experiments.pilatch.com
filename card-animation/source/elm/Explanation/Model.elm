module Explanation.Model exposing (..)

import Card exposing (Card(..))
import Process
import Random
import Task


initial seedInt =
    let
        hand =
            [ AceOfPaper, KingOfScissors, TenOfRock, QueenOfPaper, JackOfRock, JokerOfScissors ]

        ( command, steppedSeed ) =
            initialCommand seedInt <| List.length hand
    in
        ( { game =
                { animationStep = NoTransitionRearrange
                , hand = hand
                , maxHandSize = List.length hand
                , placed = Nothing
                , seed = Random.initialSeed seedInt
                }
          }
        , command
        )


initialCommand seedInt handSize =
    let
        ( cardIndex, steppedSeed ) =
            Random.step (Random.int 0 <| handSize - 1) <| Random.initialSeed seedInt
    in
        ( Task.perform (\_ -> DemoPlaceCard cardIndex) (Process.sleep 2000), steppedSeed )


type alias Model =
    { game : Game
    }


type alias Game =
    { animationStep : AnimationStep
    , hand : List Card
    , maxHandSize : Int
    , placed : Maybe Card
    , seed : Random.Seed
    }


type alias HandIndex =
    Int


type AnimationStep
    = PlaceCard HandIndex
    | NoTransitionRearrange
    | ReturnCard HandIndex


type Msg
    = DemoPlaceCard HandIndex
    | DemoRearrange RearrangeMsg
    | DemoReturnToHand Card HandIndex


type RearrangeMsg
    = RearrangeAfterAnimation (List Card) (Maybe Card)
