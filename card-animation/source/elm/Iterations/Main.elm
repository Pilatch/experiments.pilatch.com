module Iterations.Main exposing (main)

import Browser
import Html exposing (button, p, section, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Iterations.Model exposing (..)
import Iterations.View as View


main : Program () Model Msg
main =
    Browser.document
        { init = (\_ -> ( { animationNumber = 0, implementation = NoneChosen }, Cmd.none ))
        , subscriptions = (\_ -> Sub.none)
        , view = View.view
        , update = update
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
