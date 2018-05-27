module Main exposing (..)

import Model as Model
import View as View
import Update as Update
import Html exposing (beginnerProgram)


main : Program Never Model.Model Model.Msg
main =
    beginnerProgram
        { model = { animationNumber = 0, implementation = Model.NoneChosen }
        , view = View.view
        , update = Update.update
        }
