module Main exposing (..)

import Model as Model
import View as View
import Update as Update
import Html


main : Program Never Model.Model Model.Msg
main =
    Html.program
        { init = ( { animationNumber = 0, implementation = Model.NoneChosen }, Cmd.none )
        , view = View.view
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }
