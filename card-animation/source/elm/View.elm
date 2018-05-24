module View exposing (view)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_, value)
import Html.Events exposing (..)


emptyArea =
    pCard [ placedAreaClass, blank ]


hidden =
    attribute "hidden" ""


aceOfScissors attribute =
    pCard (attribute :: [ up, rank "14", suit "scissors" ])


queenOfScissors attribute =
    pCard (attribute :: [ up, rank "12", suit "scissors" ])


kingOfRock attribute =
    pCard (attribute :: [ up, rank "13", suit "rock" ])


threeOfRock attribute =
    pCard (attribute :: [ up, rank "3", suit "rock" ])


fiveOfPaper attribute =
    pCard (attribute :: [ up, rank "5", suit "paper" ])


fiveOfPaper_ attribute1 attribute2 =
    pCard (attribute1 :: attribute2 :: [ up, rank "5", suit "paper" ])


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


render model comment cards =
    section []
        [ next (model.animationNumber + 1)
        , text <| comment ++ " Animation: " ++ toString (model.animationNumber + 1)
        , tableTop
            cards
        ]


view model =
    case model.animationNumber of
        0 ->
            render model
                "Initial setup with invisible card between placed area and hand"
                [ queenOfScissors card1
                , fiveOfPaper card2
                , kingOfRock card3
                , threeOfRock card4
                , invisible
                , emptyArea
                ]

        1 ->
            render model
                "Swap invisible card with card to move's attributes, and hide the original (clicked card)"
                [ queenOfScissors card1
                , fiveOfPaper hidden
                , kingOfRock card3
                , threeOfRock card4
                , fiveOfPaper card2
                , emptyArea
                ]

        2 ->
            render model
                "add new attributes/classes to make the card animate"
                [ queenOfScissors card1
                , invisible
                , kingOfRock card3
                , threeOfRock card4
                , fiveOfPaper_ card2 placedAreaClass
                , emptyArea
                ]

        3 ->
            render model
                "remove classes from animated card's previous spot"
                [ queenOfScissors card1
                , invisible
                , kingOfRock card3
                , threeOfRock card4
                , fiveOfPaper placedAreaClass
                , emptyArea
                ]

        4 ->
            render model
                "remaining hand slides left"
                [ queenOfScissors card1
                , kingOfRock hidden
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper placedAreaClass
                , emptyArea
                ]

        5 ->
            render model
                "move invisible card down one notch"
                [ queenOfScissors card1
                , kingOfRock card2
                , kingOfRock hidden
                , threeOfRock card3
                , fiveOfPaper placedAreaClass
                , emptyArea
                ]

        6 ->
            render model
                "move invisible card down again"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , threeOfRock hidden
                , fiveOfPaper placedAreaClass
                , emptyArea
                ]

        7 ->
            render model
                "return five of paper to end of hand"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , invisible
                , fiveOfPaper card4
                , emptyArea
                ]

        8 ->
            render model
                "swap invisible card to initial spot"
                [ queenOfScissors card1
                , kingOfRock card2
                , threeOfRock card3
                , fiveOfPaper card4
                , invisible
                , emptyArea
                ]

        _ ->
            section []
                [ button [ onClick <| DoAnimation 0 ] [ text "START OVER" ]
                , tableTop []
                ]
