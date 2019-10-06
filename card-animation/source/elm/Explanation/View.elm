module Explanation.View exposing (view)

import Card exposing (Card, Facing(..), cardToString, webComponent)
import Explanation.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Html.Keyed
import String.Interpolate exposing (interpolate)


view : Model -> Html Msg
view model =
    Html.Keyed.node "section" [ class "table-top" ] <|
        [ ( "empty-placed-card-area", emptyArea ) ]
            ++ viewHand model
            ++ viewPlaced model


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


viewPlaced : Model -> List ( String, Html Msg )
viewPlaced model =
    case model.placed.maybeCard of
        Nothing ->
            []

        Just placedCard ->
            case model.placed.animation of
                DuplicateAtPlaced handCard ->
                    [ ( cardToString handCard, webComponent [ noTransition, placedClass ] Down handCard ) ]

                ReturnPlacedCardToHand ->
                    [ ( cardToString placedCard
                      , webComponent [ handClass model.maxHandSize <| List.length model.hand.cards - 1 ] Up placedCard
                      )
                    ]

                NoPlacedAnimation ->
                    [ ( cardToString placedCard, webComponent [ noTransition, placedClass ] Down placedCard ) ]



-- HELPERS


emptyArea =
    node "pilatch-card" [ placedClass, attribute "nothing" "" ] []


handClass maxHandSize handIndex =
    interpolate "player-hand hand-size-{0} card-{1}" [ String.fromInt maxHandSize, String.fromInt handIndex ] |> class


placedClass =
    class "player-placed-card-area"


noTransition =
    attribute "no-transition" ""
