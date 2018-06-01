module Explanation.View exposing (view)

import Card exposing (Card, Facing(..), webComponent)
import Explanation.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, id, property, type_)
import Json.Encode as Encode


innerHTML =
    property "innerHTML" << Encode.string


oneParentApproachInnerHTML =
    innerHTML """The next concept was to have a table-top element that would contain each game element without additional nesting.
The table-top's style is <code>position: relative;</code> and each card within it is <code>position: absolute;</code>
allowing the cards to float around on the table top by adding or removing CSS classes from them.
"""


oneParentExampleInnerHTML =
    innerHTML """&lt;pilatch-card hand-1 rank="5" suit="scissors"&gt;&lt;/pilatch-card&gt;
&lt;pilatch-card placed hand-2 rank="12" suit="rock"&gt;&lt;/pilatch-card&gt;
&lt;pilatch-card hand-3 rank="1" suit="paper"&gt;&lt;/pilatch-card&gt;
"""


oneParentSecondRenderExampleInnerHTML =
    innerHTML """&lt;pilatch-card hand-1 rank="5" suit="scissors"&gt;&lt;/pilatch-card&gt;
&lt;pilatch-card hand-2 rank="1" suit="paper"&gt;&lt;/pilatch-card&gt;
&lt;pilatch-card placed rank="12" suit="rock"&gt;&lt;/pilatch-card&gt;
"""


webComponentsApproachInnerHTML =
    innerHTML """&lt;pilatch-hand&gt;
  &lt;pilatch-card rank="5" suit="scissors"&gt;&lt;/pilatch-card&gt;
  &lt;pilatch-card rank="12" suit="rock"&gt;&lt;/pilatch-card&gt;
  &lt;pilatch-card rank="1" suit="paper"&gt;&lt;/pilatch-card&gt;
&lt;/pilatch-hand&gt;
&lt;placed-card-area&gt;&lt;/placed-card-area&gt;
"""


view : Model -> Html Msg
view model =
    section [ class "explanation" ]
        [ h1 [] [ text "Virtual DOM Card Game Animations" ]
        , tableTop model.game
        , p [] [ text """
            This illustrates how I approached the problem of animating cards smoothly between a player's hand and the table-top.
            My initial attempt involved creating a web component for each spot in the game, like so:""" ]
        , figure []
            [ pre [ webComponentsApproachInnerHTML ] []
            , figcaption [] [ text "A hand of three pilatch cards with an empty area waiting for the player to place a card" ]
            ]
        , p [] [ text """
            Each web component was responsible for positioning the cards contained within it, which was great for abstraction and separation of concerns.
            However it failed because the concept of moving a card from the hand to the placed card area didn't apply in virtual DOM.
            The renderer would destroy the card that was in the hand, and re-make it at its destination.
            That didn't play well with animations, as cards would just pop in and out of existence.""" ]
        , p [ oneParentApproachInnerHTML ] []
        , p [] [ text "Using this approach I could place a card from the player's hand just by adding an attribute to it, such as ", code [] [ text "placed" ], text "." ]
        , figure []
            [ pre [ oneParentExampleInnerHTML ] []
            , figcaption [] [ text "A hand of two pilatch cards, with the queen of rock placed on the table" ]
            ]
        , p []
            [ text """
            Yet a problem arose with this approach too because it's still necessary to move a card in the DOM after it has been animated, which triggered unwanted animations.
            If you didn't do this, your model of the game state would be a nightmare.
            To explain, in the example above I would need a separate render thereafter to remove the """
            , code [] [ text "card-2" ]
            , text """ attribute from the middle card, put it underneath the two cards in the player's hand, and nudge the one of paper from """
            , code [] [ text "card-3" ]
            , text " to "
            , code [] [ text "card-2" ]
            , text " to make the remaining cards in hand fill the gap that was left by the placed card. So it would have looked like this:"
            ]
        , figure []
            [ pre [ oneParentSecondRenderExampleInnerHTML ] []
            , figcaption [] [ text "So close to a workable implementation!" ]
            ]
        , h2 [] [ text "Solution" ]
        , p [] [ text "When rearranging the cards in the DOM, I had to turn off CSS animations. It took a number of iterations to come to this conclusion." ]
        , p [] [ text "In each demonstration you can step through the animations by clicking the NEXT button that appears in the upper left corner." ]
        , p [] [ text "The goal is the same in each: to place the five of paper face-down, rearrange the remaining cards in hand, then return the card to hand." ]
        , h2 [] [ a [ href "iterations.html" ] [ text "Iterations" ] ]
        ]


tableTop game =
    let
        classes =
            [ class "table-top", class "half-height" ]

        attributes =
            case game.animationStep of
                NoTransitionRearrange ->
                    [ noTransition ]

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
                            [ handClassNoMath cardNumber ]
                                ++ if handIndex == listIndex then
                                    [ placedClass ]
                                   else
                                    []
                    in
                        webComponent attributes facing card
            in
                List.indexedMap mapper

        NoTransitionRearrange ->
            let
                mapper handIndex card =
                    webComponent [ handClass handIndex, noTransition ] Up card
            in
                List.indexedMap mapper

        ReturnCard _ ->
            let
                mapper handIndex card =
                    webComponent [ handClass handIndex ] Up card
            in
                List.indexedMap mapper


placedCardArea : AnimationStep -> Maybe Card -> List (Html msg)
placedCardArea step maybeCard =
    let
        emptyArea =
            [ node "pilatch-card" [ placedClass, attribute "nothing" "" ] [] ]

        placed =
            case maybeCard of
                Nothing ->
                    []

                Just card ->
                    case step of
                        PlaceCard _ ->
                            []

                        NoTransitionRearrange ->
                            [ webComponent [ placedClass, noTransition ] Down card ]

                        ReturnCard handIndex ->
                            [ webComponent [ handClass handIndex ] Up card ]
    in
        placed ++ emptyArea


handClass =
    handClassNoMath << (+) 1


handClassNoMath handIndex =
    handIndex |> toString |> (++) "player-hand card-" |> class


placedClass =
    class "player-placed-card-area"


noTransition =
    attribute "no-transition" ""
