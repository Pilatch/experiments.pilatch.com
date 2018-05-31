module Model exposing (..)

import Card exposing (Card(..))
import Process
import Random
import Task


initial seedInt =
    let
        hand =
            [ AceOfPaper, KingOfScissors, EightOfRock, QueenOfPaper ]

        ( command, steppedSeed ) =
            initialCommand seedInt <| List.length hand
    in
        ( { animationNumber = 0
          , implementation = NoneChosen
          , game =
                { animationStep = NoTransitionRearrange
                , hand = hand
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
    { animationNumber : Int
    , implementation : Implementation
    , game : Game
    }


type alias Game =
    { animationStep : AnimationStep
    , hand : List Card
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
    = ChooseImplementation Implementation
    | DemoPlaceCard HandIndex
    | DemoRearrange RearrangeMsg
    | DemoReturnToHand Card HandIndex
    | DoAnimation Int
    | StartOver
    | ScrollToChoose


type Implementation
    = NoneChosen
    | Naive
    | InvisibleCard
    | DisablingTransitions
    | Collapsed


type RearrangeMsg
    = RearrangeAfterAnimation (List Card) (Maybe Card)
