port module Update exposing (update)

import Card exposing (Card)
import Model exposing (..)
import Navigation
import Process
import Random
import Task
import List.Extra


port goToHash : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseImplementation implementation ->
            ( { model | implementation = implementation, animationNumber = 0 }, Navigation.modifyUrl "#" )

        DemoPlaceCard handIndex ->
            let
                modelGame =
                    model.game

                newGame =
                    { modelGame | animationStep = PlaceCard handIndex }

                placed =
                    List.Extra.getAt handIndex model.game.hand

                nextHand =
                    List.Extra.removeAt handIndex model.game.hand

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand placed) (Process.sleep 1500)
            in
                ( { model | game = newGame }, command )

        DemoRearrange rearrangeMsg ->
            case rearrangeMsg of
                RearrangeAfterAnimation hand placed ->
                    let
                        modelGame =
                            model.game

                        ( command, seed ) =
                            case placed of
                                Nothing ->
                                    let
                                        ( placeCardIndex, newSeed ) =
                                            Random.step (Random.int 0 <| (List.length hand) - 1) modelGame.seed
                                    in
                                        ( Task.perform (\_ -> DemoPlaceCard placeCardIndex) (Process.sleep 1500), newSeed )

                                Just placedCard ->
                                    ( Task.perform (\_ -> DemoReturnToHand placedCard <| List.length hand) (Process.sleep 1500), modelGame.seed )

                        newGame =
                            { modelGame | hand = hand, placed = placed, animationStep = NoTransitionRearrange, seed = seed }
                    in
                        ( { model | game = newGame }, command )

        DemoReturnToHand card handIndex ->
            let
                modelGame =
                    model.game

                newGame =
                    { modelGame | animationStep = ReturnCard handIndex }

                nextHand =
                    modelGame.hand ++ [ card ]

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand Nothing) (Process.sleep 1500)
            in
                ( { model | game = newGame }, command )

        DoAnimation animationNumber ->
            ( { model | animationNumber = animationNumber }, Cmd.none )

        StartOver ->
            ( { model | implementation = NoneChosen, animationNumber = 0 }, Process.sleep 17 |> Task.perform (\_ -> ScrollToChoose) )

        ScrollToChoose ->
            ( model, goToHash "choose" )
