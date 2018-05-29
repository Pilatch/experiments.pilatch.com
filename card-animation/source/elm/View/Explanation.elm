module View.Explanation exposing (view)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, id, property, type_)
import Html.Events exposing (onClick)
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


view =
    section [ class "explanation" ]
        [ h1 [] [ text "Card Animation Demonstrations" ]
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
        , h2 [ id "choose" ] [ text "Choose an implementation:" ]
        , p [] [ button [ type_ "button", onClick <| ChooseImplementation Naive ] [ text "Naïve" ] ]
        , p [] [ button [ type_ "button", onClick <| ChooseImplementation InvisibleCard ] [ text "Invisible Card" ] ]
        , p [] [ button [ type_ "button", onClick <| ChooseImplementation DisablingTransitions ] [ text "Disabling Transitions" ] ]
        , p [] [ button [ type_ "button", onClick <| ChooseImplementation Collapsed ] [ text "Collapsed" ] ]
        ]
