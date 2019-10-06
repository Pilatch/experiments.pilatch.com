module Explanation.View exposing (view)

import Card exposing (Card, Facing(..), cardToString, webComponent)
import Explanation.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Html.Keyed
import List.Extra
import String.Interpolate exposing (interpolate)


view : Model -> Html Msg
view model =
    section [ class "table-top" ]
        [ div [] <| viewPlaced model
        , Html.Keyed.node "div" [] <| viewHand model
        ]


viewHand : Model -> List ( String, Html Msg )
viewHand model =
    List.indexedMap
        (\i card ->
            let
                html =
                    case model.hand.animation of
                        NoHandAnimation ->
                            webComponent [ noTransition, handClass model.maxHandSize i ] Up card

                        PlaceHandCard handIndex ->
                            if i == handIndex then
                                webComponent [ placedClass, handClass model.maxHandSize i ] Down card

                            else if i > handIndex then
                                webComponent [ handClass model.maxHandSize <| i - 1 ] Up card

                            else
                                webComponent [ handClass model.maxHandSize i ] Up card
            in
            ( cardToString card, html )
        )
        model.hand.cards


viewPlaced : Model -> List (Html Msg)
viewPlaced model =
    emptyArea
        ++ (case model.placed.maybeCard of
                Nothing ->
                    []

                Just placedCard ->
                    case model.placed.animation of
                        DuplicateAtPlaced handCard ->
                            -- probably don't need handClass
                            -- handClass model.maxHandSize <| List.length model.hand.cards
                            [ webComponent [ noTransition, placedClass ] Down handCard ]

                        ReturnPlacedCardToHand ->
                            [ webComponent [ placedClass, handClass model.maxHandSize <| List.length model.hand.cards ] Up placedCard ]

                        NoPlacedAnimation ->
                            [ webComponent [ noTransition, placedClass ] Down placedCard ]
           )



-- HELPERS


emptyArea =
    [ node "pilatch-card" [ placedClass, attribute "nothing" "" ] [] ]


handClass maxHandSize handIndex =
    interpolate "player-hand hand-size-{0} card-{1}" [ String.fromInt maxHandSize, String.fromInt handIndex ] |> class


placedClass =
    class "player-placed-card-area"


noTransition =
    attribute "no-transition" ""
