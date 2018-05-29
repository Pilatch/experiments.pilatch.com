port module Update exposing (update)

import Model exposing (..)
import Navigation
import Process
import Task


port goToHash : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseImplementation implementation ->
            ( { implementation = implementation, animationNumber = 0 }, Navigation.modifyUrl "#" )

        DoAnimation animationNumber ->
            ( { model | animationNumber = animationNumber }, Cmd.none )

        StartOver ->
            ( { implementation = NoneChosen, animationNumber = 0 }, Process.sleep 17 |> Task.perform (\_ -> ScrollToChoose) )

        ScrollToChoose ->
            ( model, goToHash "choose" )
