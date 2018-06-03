module Explanation.Update exposing (update)

import Explanation.Model exposing (..)
import Process
import Random
import Task
import List.Extra


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoPlaceCard handIndex ->
            let
                modelGame =
                    model.game

                newGame =
                    { modelGame | animationStep = PlaceCard handIndex }

                nextPlaced =
                    List.Extra.getAt handIndex model.game.hand

                nextHand =
                    case model.game.placed of
                        Nothing ->
                            List.Extra.removeAt handIndex model.game.hand

                        Just card ->
                            (List.Extra.removeAt handIndex model.game.hand) ++ [ card ]

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand nextPlaced) (Process.sleep 1250)
            in
                ( { model | game = newGame }, command )

        DemoRearrange rearrangeMsg ->
            case rearrangeMsg of
                RearrangeAfterAnimation hand placed ->
                    let
                        modelGame =
                            model.game

                        ( command, seed ) =
                            let
                                ( placeCardIndex, newSeed ) =
                                    Random.step (Random.int 0 <| (List.length hand) - 1) modelGame.seed
                            in
                                ( Task.perform (\_ -> DemoPlaceCard placeCardIndex) (Process.sleep 1250), newSeed )

                        newGame =
                            { modelGame | hand = hand, placed = placed, animationStep = NoTransitionRearrange, seed = seed }
                    in
                        ( { model | game = newGame }, command )
