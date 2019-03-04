module Explanation.Update exposing (naiveUpdate, update)

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
                newModel =
                    { model | animationStep = PlaceCard handIndex }

                nextPlaced =
                    List.Extra.getAt handIndex model.hand

                nextHand =
                    case model.placed of
                        Nothing ->
                            List.Extra.removeAt handIndex model.hand

                        Just card ->
                            (List.Extra.removeAt handIndex model.hand) ++ [ card ]

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand nextPlaced) (Process.sleep 1250)
            in
                ( newModel, command )

        DemoRearrange rearrangeMsg ->
            case rearrangeMsg of
                RearrangeAfterAnimation hand placed ->
                    let
                        ( command, seed ) =
                            let
                                ( placeCardIndex, newSeed ) =
                                    Random.step (Random.int 0 <| (List.length hand) - 1) model.seed
                            in
                                ( Task.perform (\_ -> DemoPlaceCard placeCardIndex) (Process.sleep 1250), newSeed )

                        newModel =
                            { model | hand = hand, placed = placed, animationStep = NoTransitionRearrange, seed = seed }
                    in
                        ( newModel, command )


naiveUpdate : Msg -> Model -> ( Model, Cmd Msg )
naiveUpdate msg model =
    case msg of
        DemoPlaceCard handIndex ->
            let
                newModel =
                    { model | animationStep = PlaceCard handIndex }

                nextPlaced =
                    List.Extra.getAt handIndex model.hand

                nextHand =
                    case model.placed of
                        Nothing ->
                            List.Extra.removeAt handIndex model.hand

                        Just card ->
                            (List.Extra.removeAt handIndex model.hand) ++ [ card ]

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand nextPlaced) (Process.sleep 2500)
            in
                ( newModel, command )

        DemoRearrange rearrangeMsg ->
            case rearrangeMsg of
                RearrangeAfterAnimation hand placed ->
                    let
                        command =
                            Task.perform (\_ -> DemoPlaceCard 0) (Process.sleep 2500)

                        newModel =
                            { model | hand = hand, placed = placed, animationStep = NaiveRearrange }
                    in
                        ( newModel, command )
