module Model exposing (..)


type alias Model =
    { animationNumber : Int
    , implementation : Implementation
    }


type Msg
    = ChooseImplementation Implementation
    | DoAnimation Int
    | StartOver
    | ScrollToChoose


type Implementation
    = NoneChosen
    | Naive
    | InvisibleCard
    | DisablingTransitions
    | Collapsed
