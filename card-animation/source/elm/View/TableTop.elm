module View.TableTop exposing (view)

import Card exposing (Card, Facing(..), webComponent)
import Html exposing (Html, node, section)
import Html.Attributes exposing (attribute, class)
import Model exposing (Game, AnimationStep(..))


view : Game -> Html msg
view game =
    let
        classes =
            [ class "table-top", class "half-height" ]

        attributes =
            case game.animationStep of
                NoTransitionRearrange ->
                    [ attribute "no-transition" "" ]

                _ ->
                    []
    in
        section (classes ++ attributes) <|
            List.concat
                [ hand game.animationStep game.hand
                , placedCardArea game.animationStep game.placed
                ]


hand : AnimationStep -> List Card -> List (Html msg)
hand step =
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
                                listIndex + 1
                            else
                                listIndex

                        attributes =
                            [ class <| "player-hand card-" ++ (toString cardNumber) ]
                                ++ if handIndex == listIndex then
                                    [ class "player-placed-card-area" ]
                                   else
                                    []
                    in
                        webComponent attributes facing card
            in
                List.indexedMap mapper

        NoTransitionRearrange ->
            let
                mapper handIndex card =
                    webComponent [ class <| "player-hand card-" ++ (toString <| handIndex + 1), attribute "no-transition" "" ] Up card
            in
                List.indexedMap mapper

        ReturnCard _ ->
            let
                mapper handIndex card =
                    webComponent [ class <| "player-hand card-" ++ (toString <| handIndex + 1) ] Up card
            in
                List.indexedMap mapper


placedCardArea : AnimationStep -> Maybe Card -> List (Html msg)
placedCardArea step maybeCard =
    let
        emptyArea =
            [ node "pilatch-card" [ class "player-placed-card-area", attribute "nothing" "" ] [] ]

        placed =
            case maybeCard of
                Nothing ->
                    []

                Just card ->
                    case step of
                        PlaceCard _ ->
                            []

                        NoTransitionRearrange ->
                            [ webComponent [ class "player-placed-card-area", attribute "no-transition" "" ] Down card ]

                        ReturnCard handIndex ->
                            [ webComponent [ class <| "player-hand card-" ++ (toString <| (+) 1 <| handIndex) ] Up card ]
    in
        placed ++ emptyArea
