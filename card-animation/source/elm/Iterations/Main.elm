module Iterations.Main exposing (main)

import Html exposing (button, p, section, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Iterations.View as View
import Iterations.Model exposing (..)


main =
    Html.beginnerProgram
        { model = { animationNumber = 0, implementation = NoneChosen }
        , view = View.view
        , update = update
        }


update msg model =
    case msg of
        ChooseImplementation implementation ->
            { model | implementation = implementation, animationNumber = 0 }

        DoAnimation animationNumber ->
            { model | animationNumber = animationNumber }

        StartOver ->
            { model | implementation = NoneChosen, animationNumber = 0 }
