module Iterations.Main exposing (main)

import Browser
import Html exposing (button, p, section, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Iterations.Model exposing (..)
import Iterations.View as View


main =
    Browser.document
        { init = \() -> ( { animationNumber = 0, implementation = NoneChosen }, Cmd.none )
        , view = View.view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update msg model =
    let
        newModel =
            case msg of
                ChooseImplementation implementation ->
                    { model | implementation = implementation, animationNumber = 0 }

                DoAnimation animationNumber ->
                    { model | animationNumber = animationNumber }

                StartOver ->
                    { model | implementation = NoneChosen, animationNumber = 0 }
    in
    ( newModel, Cmd.none )
