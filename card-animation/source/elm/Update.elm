module Update exposing (update)

import Model exposing (Model, Msg(..))


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoAnimation animationNumber ->
            { animationNumber = animationNumber }
