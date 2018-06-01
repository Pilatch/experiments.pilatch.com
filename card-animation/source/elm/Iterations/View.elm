module Iterations.View exposing (view)

import Iterations.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, id, placeholder, property, type_, value)
import Html.Events exposing (onClick)


view model =
    case model.implementation of
        NoneChosen ->
            section []
                [ header []
                    [ h1 [] [ text "Iterative Development" ]
                    , p [] [ text "The experiments and refinements I went through to make animations work with virtual DOM." ]
                    ]
                , p [] [ button [ type_ "button", onClick <| ChooseImplementation Naive ] [ text "Naïve" ] ]
                , p [] [ button [ type_ "button", onClick <| ChooseImplementation InvisibleCard ] [ text "Invisible Card" ] ]
                , p [] [ button [ type_ "button", onClick <| ChooseImplementation DisablingTransitions ] [ text "Disabling Transitions" ] ]
                , p [] [ button [ type_ "button", onClick <| ChooseImplementation Collapsed ] [ text "Collapsed" ] ]
                , p []
                    [ a [ href "index.html" ] [ text "Back to explanation" ]
                    ]
                ]

        Naive ->
            naiveImplementation model.animationNumber

        InvisibleCard ->
            invisibleCardImplementation model.animationNumber

        DisablingTransitions ->
            disablingTransitionsImplementation model.animationNumber

        Collapsed ->
            collapsedImplementation model.animationNumber


emptyArea =
    pCard [ placedAreaClass, blank ]


hidden =
    attribute "hidden" ""


noTransition =
    attribute "no-transition" ""


aceOfScissors attribute =
    pCard [ attribute, up, rank "14", suit "scissors" ]


queenOfScissors attribute =
    pCard [ attribute, up, rank "12", suit "scissors" ]


queenOfScissors2 attribute1 attribute2 =
    pCard [ attribute1, attribute2, up, rank "12", suit "scissors" ]


kingOfRock attribute =
    pCard [ attribute, up, rank "13", suit "rock" ]


kingOfRock2 attribute1 attribute2 =
    pCard [ attribute1, attribute2, up, rank "13", suit "rock" ]


threeOfRock attribute =
    pCard [ attribute, up, rank "3", suit "rock" ]


threeOfRock2 attribute1 attribute2 =
    pCard [ attribute1, attribute2, up, rank "3", suit "rock" ]


fiveOfPaper attribute =
    pCard [ attribute, up, rank "5", suit "paper" ]


fiveOfPaper2 attribute1 attribute2 =
    pCard [ attribute1, attribute2, up, rank "5", suit "paper" ]


fiveOfPaperDown attribute =
    pCard [ attribute, rank "5", suit "paper" ]


fiveOfPaperDown2 attribute1 attribute2 =
    pCard [ attribute1, attribute2, rank "5", suit "paper" ]


up =
    attribute "up" ""


rank =
    attribute "rank"


suit =
    attribute "suit"


blank =
    attribute "nothing" ""


pCard attributes =
    node "pilatch-card" attributes []


placedAreaClass =
    class "player-placed-card-area"


card1 =
    class "player-hand card-1"


card2 =
    class "player-hand card-2"


card3 =
    class "player-hand card-3"


card4 =
    class "player-hand card-4"


invisible =
    pCard [ hidden ]


next animationNumber =
    button [ onClick <| DoAnimation animationNumber ] [ text "NEXT" ]


tableTop =
    div [ class "table-top" ]


tableTop1 attribute =
    div [ attribute, class "table-top" ]


sourceCodezLink =
    a [ href "https://github.com/Pilatch/experiments.pilatch.com/tree/master/card-animation" ] [ text "Source codez" ]


startOver =
    section []
        [ button [ onClick <| StartOver ] [ text "START OVER" ]
        , sourceCodezLink
        , tableTop []
        ]


render animationNumber comment cards =
    section []
        [ div [ class "interaction" ]
            [ next (animationNumber + 1)
            , text <| comment ++ ". Animation: " ++ toString (animationNumber + 1)
            ]
        , tableTop
            cards
        ]


renderNoTransition animationNumber comment cards =
    section []
        [ div [ class "interaction" ]
            [ next (animationNumber + 1)
            , text <| comment ++ ". Animation: " ++ toString (animationNumber + 1)
            ]
        , tableTop1 noTransition
            cards
        ]


naiveImplementation animationNumber =
    case animationNumber of
        0 ->
            render animationNumber
                "Initial setup with four cards in hand and an empty placed card area"
                [ queenOfScissors card1
                , fiveOfPaper card2
                , kingOfRock card3
                , threeOfRock card4
                , emptyArea
                ]

        1 ->
            render animationNumber
                "add new attributes/classes to make the five of paper card animate"
                [ queenOfScissors card1
                , pCard [ card2, placedAreaClass, rank "5", suit "paper" ]
                , kingOfRock card3
                , threeOfRock card4
                , emptyArea
                ]

        2 ->
            render animationNumber
                "remove classes from animated card's previous spot in hand"
                [ queenOfScissors card1
                , fiveOfPaperDown placedAreaClass
                , kingOfRock card3
                , threeOfRock card4
                , emptyArea
                ]

        3 ->
            render animationNumber
                "rearrange cards to match new layout"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        4 ->
            render animationNumber
                "return five of paper to end of hand"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper card4
                , emptyArea
                ]

        _ ->
            startOver


invisibleCardImplementation animationNumber =
    case animationNumber of
        0 ->
            render animationNumber
                "Initial setup with invisible card between placed area and hand"
                [ queenOfScissors card1
                , fiveOfPaper card2
                , kingOfRock card3
                , threeOfRock card4
                , invisible
                , emptyArea
                ]

        1 ->
            render animationNumber
                "Swap invisible card with card to move's attributes, and hide the original (clicked card)"
                [ queenOfScissors card1
                , fiveOfPaper hidden
                , kingOfRock card3
                , threeOfRock card4
                , fiveOfPaper card2
                , emptyArea
                ]

        2 ->
            render animationNumber
                "add new attributes/classes to make the card animate"
                [ queenOfScissors card1
                , invisible
                , kingOfRock card3
                , threeOfRock card4
                , pCard [ card2, placedAreaClass, rank "5", suit "paper" ]
                , emptyArea
                ]

        3 ->
            render animationNumber
                "remove classes from animated card's previous spot"
                [ queenOfScissors card1
                , invisible
                , kingOfRock card3
                , threeOfRock card4
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        4 ->
            render animationNumber
                "remaining hand slides left"
                [ queenOfScissors card1
                , kingOfRock hidden
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        5 ->
            render animationNumber
                "move invisible card down one notch"
                [ queenOfScissors card1
                , kingOfRock card2
                , kingOfRock hidden
                , threeOfRock card3
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        6 ->
            render animationNumber
                "move invisible card down again"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , threeOfRock hidden
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        7 ->
            render animationNumber
                "return five of paper to end of hand"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , invisible
                , fiveOfPaper card4
                , emptyArea
                ]

        8 ->
            render animationNumber
                "swap invisible card to initial spot"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper card4
                , invisible
                , emptyArea
                ]

        _ ->
            startOver


disablingTransitionsImplementation animationNumber =
    case animationNumber of
        0 ->
            render animationNumber
                "Initial setup with four cards in hand and an empty placed card area"
                [ queenOfScissors2 card1 noTransition
                , fiveOfPaper2 card2 noTransition
                , kingOfRock2 card3 noTransition
                , threeOfRock2 card4 noTransition
                , emptyArea
                ]

        1 ->
            render animationNumber
                "add new attributes/classes to make the five of paper card animate"
                [ queenOfScissors card1
                , pCard [ card2, placedAreaClass, rank "5", suit "paper" ]
                , kingOfRock card3
                , threeOfRock card4
                , emptyArea
                ]

        2 ->
            render animationNumber
                "remove classes from animated card's previous spot in hand"
                [ queenOfScissors card1
                , fiveOfPaperDown placedAreaClass
                , kingOfRock card3
                , threeOfRock card4
                , emptyArea
                ]

        3 ->
            renderNoTransition animationNumber
                "move it in the DOM with transitions disabled in CSS"
                [ queenOfScissors card1
                , kingOfRock2 card3 noTransition
                , threeOfRock2 card4 noTransition
                , fiveOfPaperDown2 placedAreaClass noTransition
                , emptyArea
                ]

        4 ->
            render animationNumber
                "slide the cards in hand to the left"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaperDown placedAreaClass
                , emptyArea
                ]

        5 ->
            render animationNumber
                "return five of paper to end of hand"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper card4
                , emptyArea
                ]

        _ ->
            startOver


collapsedImplementation animationNumber =
    case animationNumber of
        0 ->
            render animationNumber
                "Initial setup with four cards in hand and an empty placed card area"
                [ queenOfScissors2 card1 noTransition
                , fiveOfPaper2 card2 noTransition
                , kingOfRock2 card3 noTransition
                , threeOfRock2 card4 noTransition
                , emptyArea
                ]

        1 ->
            render animationNumber
                "add new attributes/classes to make the five of paper card animate, and slide cards in hand to the left"
                [ queenOfScissors card1
                , pCard [ card2, placedAreaClass, rank "5", suit "paper" ]
                , kingOfRock card2
                , threeOfRock card3
                , emptyArea
                ]

        2 ->
            renderNoTransition animationNumber
                "move it in the DOM with transitions disabled in CSS"
                [ queenOfScissors card1
                , kingOfRock2 card2 noTransition
                , threeOfRock2 card3 noTransition
                , fiveOfPaperDown2 placedAreaClass noTransition
                , emptyArea
                ]

        3 ->
            render animationNumber
                "return five of paper to end of hand"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper card4
                , emptyArea
                ]

        _ ->
            startOver
