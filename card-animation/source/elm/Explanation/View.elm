module Explanation.View exposing (view)

import Card exposing (Card, Facing(..), webComponent)
import Explanation.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import String.Interpolate exposing (interpolate)


view : { a | game : Game } -> Html Msg
view { game } =
    let
        classes =
            [ class "table-top" ]

        attributes =
            case game.animationStep of
                NoTransitionRearrange ->
                    [ noTransition ]

                _ ->
                    []
    in
        section (classes ++ attributes) <|
            List.concat
                [ hand game.animationStep game.maxHandSize game.hand
                , placedCardArea game.animationStep game.maxHandSize (List.length game.hand) game.placed
                ]


hand : AnimationStep -> Int -> List Card -> List (Html msg)
hand step maxHandSize cards =
    case step of
        PlaceCard handIndex ->
            let
                mapper listIndex card =
                    let
                        facing =
                            if listIndex == handIndex then
                                Down
                            else
                                Up

                        cardNumber =
                            if listIndex <= handIndex then
                                listIndex
                            else
                                listIndex - 1

                        attributes =
                            [ handClass maxHandSize cardNumber ]
                                ++ if handIndex == listIndex then
                                    [ placedClass ]
                                   else
                                    []
                    in
                        webComponent attributes facing card
            in
                List.indexedMap mapper cards

        NoTransitionRearrange ->
            let
                mapper handIndex card =
                    webComponent [ handClass maxHandSize handIndex, noTransition ] Up card
            in
                List.indexedMap mapper cards


placedCardArea : AnimationStep -> Int -> Int -> Maybe Card -> List (Html msg)
placedCardArea step maxHandSize currentHandSize maybeCard =
    let
        emptyArea =
            [ node "pilatch-card" [ placedClass, attribute "nothing" "" ] [] ]

        placed =
            case maybeCard of
                Nothing ->
                    []

                Just card ->
                    case step of
                        PlaceCard handIndex ->
                            [ webComponent [ handClass maxHandSize <| currentHandSize - 1 ] Up card ]

                        NoTransitionRearrange ->
                            [ webComponent [ placedClass, noTransition ] Down card ]
    in
        placed ++ emptyArea


handClass maxHandSize handIndex =
    interpolate "player-hand hand-size-{0} card-{1}" [ toString maxHandSize, toString handIndex ] |> class


placedClass =
    class "player-placed-card-area"


noTransition =
    attribute "no-transition" ""
