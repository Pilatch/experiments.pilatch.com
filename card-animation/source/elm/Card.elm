module Card exposing (Card(..), Facing(..), cardToString, webComponent)

import Html exposing (node)
import Html.Attributes exposing (attribute)
import String


type Card
    = OneOfPaper
    | TwoOfPaper
    | ThreeOfPaper
    | FourOfPaper
    | FiveOfPaper
    | SixOfPaper
    | SevenOfPaper
    | EightOfPaper
    | NineOfPaper
    | TenOfPaper
    | JackOfPaper
    | QueenOfPaper
    | KingOfPaper
    | AceOfPaper
    | JokerOfPaper
    | OneOfRock
    | TwoOfRock
    | ThreeOfRock
    | FourOfRock
    | FiveOfRock
    | SixOfRock
    | SevenOfRock
    | EightOfRock
    | NineOfRock
    | TenOfRock
    | JackOfRock
    | QueenOfRock
    | KingOfRock
    | AceOfRock
    | JokerOfRock
    | OneOfScissors
    | TwoOfScissors
    | ThreeOfScissors
    | FourOfScissors
    | FiveOfScissors
    | SixOfScissors
    | SevenOfScissors
    | EightOfScissors
    | NineOfScissors
    | TenOfScissors
    | JackOfScissors
    | QueenOfScissors
    | KingOfScissors
    | AceOfScissors
    | JokerOfScissors


type Rank
    = One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King
    | Ace
    | Joker


type Suit
    = Rock
    | Paper
    | Scissors


type Facing
    = Up
    | Down


webComponent : List (Html.Attribute msg) -> Facing -> Card -> Html.Html msg
webComponent attrs facing card =
    let
        data =
            cardToData card

        attributes =
            attrs
                ++ [ attribute "suit" <| suitToString data.suit
                   , attribute "rank" <| rankToString data.rank
                   ]
                ++ (case facing of
                        Up ->
                            [ attribute "up" "" ]

                        Down ->
                            []
                   )
    in
    node "pilatch-card" attributes []


facingToString_ facing =
    case facing of
        Up ->
            "Up"

        Down ->
            "Down"


cardToString : Card -> String
cardToString card =
    let
        data =
            cardToData card
    in
    rankToString data.rank ++ suitToString data.suit


rankToString rank =
    case rank of
        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"

        Six ->
            "6"

        Seven ->
            "7"

        Eight ->
            "8"

        Nine ->
            "9"

        Ten ->
            "10"

        Jack ->
            "11"

        Queen ->
            "12"

        King ->
            "13"

        Ace ->
            "14"

        Joker ->
            "15"


suitToString_ suit =
    case suit of
        Rock ->
            "Rock"

        Paper ->
            "Paper"

        Scissors ->
            "Scissors"


suitToString suit =
    suitToString_ suit |> String.toLower


cardToData card =
    case card of
        OneOfPaper ->
            { rank = One, suit = Paper }

        TwoOfPaper ->
            { rank = Two, suit = Paper }

        ThreeOfPaper ->
            { rank = Three, suit = Paper }

        FourOfPaper ->
            { rank = Four, suit = Paper }

        FiveOfPaper ->
            { rank = Five, suit = Paper }

        SixOfPaper ->
            { rank = Six, suit = Paper }

        SevenOfPaper ->
            { rank = Seven, suit = Paper }

        EightOfPaper ->
            { rank = Eight, suit = Paper }

        NineOfPaper ->
            { rank = Nine, suit = Paper }

        TenOfPaper ->
            { rank = Ten, suit = Paper }

        JackOfPaper ->
            { rank = Jack, suit = Paper }

        QueenOfPaper ->
            { rank = Queen, suit = Paper }

        KingOfPaper ->
            { rank = King, suit = Paper }

        AceOfPaper ->
            { rank = Ace, suit = Paper }

        JokerOfPaper ->
            { rank = Joker, suit = Paper }

        OneOfRock ->
            { rank = One, suit = Rock }

        TwoOfRock ->
            { rank = Two, suit = Rock }

        ThreeOfRock ->
            { rank = Three, suit = Rock }

        FourOfRock ->
            { rank = Four, suit = Rock }

        FiveOfRock ->
            { rank = Five, suit = Rock }

        SixOfRock ->
            { rank = Six, suit = Rock }

        SevenOfRock ->
            { rank = Seven, suit = Rock }

        EightOfRock ->
            { rank = Eight, suit = Rock }

        NineOfRock ->
            { rank = Nine, suit = Rock }

        TenOfRock ->
            { rank = Ten, suit = Rock }

        JackOfRock ->
            { rank = Jack, suit = Rock }

        QueenOfRock ->
            { rank = Queen, suit = Rock }

        KingOfRock ->
            { rank = King, suit = Rock }

        AceOfRock ->
            { rank = Ace, suit = Rock }

        JokerOfRock ->
            { rank = Joker, suit = Rock }

        OneOfScissors ->
            { rank = One, suit = Scissors }

        TwoOfScissors ->
            { rank = Two, suit = Scissors }

        ThreeOfScissors ->
            { rank = Three, suit = Scissors }

        FourOfScissors ->
            { rank = Four, suit = Scissors }

        FiveOfScissors ->
            { rank = Five, suit = Scissors }

        SixOfScissors ->
            { rank = Six, suit = Scissors }

        SevenOfScissors ->
            { rank = Seven, suit = Scissors }

        EightOfScissors ->
            { rank = Eight, suit = Scissors }

        NineOfScissors ->
            { rank = Nine, suit = Scissors }

        TenOfScissors ->
            { rank = Ten, suit = Scissors }

        JackOfScissors ->
            { rank = Jack, suit = Scissors }

        QueenOfScissors ->
            { rank = Queen, suit = Scissors }

        KingOfScissors ->
            { rank = King, suit = Scissors }

        AceOfScissors ->
            { rank = Ace, suit = Scissors }

        JokerOfScissors ->
            { rank = Joker, suit = Scissors }
