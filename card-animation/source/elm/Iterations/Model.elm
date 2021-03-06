module Iterations.Model exposing (..)


type alias Model =
    { animationNumber : Int
    , implementation : Implementation
    }


type Implementation
    = NoneChosen
    | Naive
    | InvisibleCard
    | DisablingTransitions
    | Collapsed


type Msg
    = ChooseImplementation Implementation
    | DoAnimation Int
    | StartOver
