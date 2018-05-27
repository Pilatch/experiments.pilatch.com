module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChooseImplementation implementation ->
            { implementation = implementation, animationNumber = 0 }

        DoAnimation animationNumber ->
            { model | animationNumber = animationNumber }

        StartOver ->
            { implementation = NoneChosen, animationNumber = 0 }
