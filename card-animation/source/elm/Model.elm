module Model exposing (..)


type alias Model =
    { animationNumber : Int
    }


type Msg
    = DoAnimation Int
