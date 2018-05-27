module Model exposing (..)


type alias Model =
    { animationNumber : Int
    , implementation : Implementation
    }


type Msg
    = ChooseImplementation Implementation
    | DoAnimation Int
    | StartOver


type Implementation
    = InvisibleCard
    | Naive
    | NoneChosen
