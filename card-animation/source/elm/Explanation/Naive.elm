module Explanation.Naive exposing (..)

import Browser
import Card exposing (Card(..), Facing(..), webComponent)
import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import List.Extra
import Process
import Random
import String.Interpolate exposing (interpolate)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() ->
                initialNoSeed
                    [ OneOfScissors
                    , TwoOfScissors
                    , ThreeOfScissors
                    , FourOfScissors
                    , FiveOfScissors
                    ]
        , view = naiveView
        , update = naiveUpdate
        , subscriptions = \_ -> Sub.none
        }


initialNoSeed : List Card -> ( Model, Cmd Msg )
initialNoSeed hand_ =
    ( { animationStep = NoTransitionRearrange
      , hand = hand_
      , maxHandSize = List.length hand_
      , placed = Nothing
      , seed = Random.initialSeed 8675309
      }
    , Task.perform (\_ -> DemoPlaceCard 0) (Process.sleep 2500)
    )


type alias Model =
    { animationStep : AnimationStep
    , hand : List Card
    , maxHandSize : Int
    , placed : Maybe Card
    , seed : Random.Seed
    }


type alias HandIndex =
    Int


type AnimationStep
    = PlaceCard HandIndex
    | NoTransitionRearrange
    | NaiveRearrange


type Msg
    = DemoPlaceCard HandIndex
    | DemoRearrange RearrangeMsg


type RearrangeMsg
    = RearrangeAfterAnimation (List Card) (Maybe Card)


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
                            List.Extra.removeAt handIndex model.hand ++ [ card ]

                command =
                    Task.perform (\_ -> DemoRearrange <| RearrangeAfterAnimation nextHand nextPlaced) (Process.sleep 2500)
            in
            ( newModel, command )

        DemoRearrange rearrangeMsg ->
            case rearrangeMsg of
                RearrangeAfterAnimation hand_ placed ->
                    let
                        command =
                            Task.perform (\_ -> DemoPlaceCard 0) (Process.sleep 2500)

                        newModel =
                            { model | hand = hand_, placed = placed, animationStep = NaiveRearrange }
                    in
                    ( newModel, command )


naiveView : Model -> Html Msg
naiveView model =
    let
        classes =
            [ class "table-top" ]

        attributes =
            case model.animationStep of
                NoTransitionRearrange ->
                    [ noTransition ]

                _ ->
                    []
    in
    section (classes ++ attributes) <|
        List.concat
            [ hand model.animationStep model.maxHandSize model.hand
            , placedCardArea model.animationStep model.maxHandSize (List.length model.hand) model.placed
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
                                ++ (if handIndex == listIndex then
                                        [ placedClass ]

                                    else
                                        []
                                   )
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

        NaiveRearrange ->
            let
                mapper handIndex card =
                    webComponent [ handClass maxHandSize handIndex ] Up card
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

                        NaiveRearrange ->
                            [ webComponent [ placedClass ] Down card ]
    in
    placed ++ emptyArea


handClass maxHandSize handIndex =
    interpolate "player-hand hand-size-{0} card-{1}" [ String.fromInt maxHandSize, String.fromInt handIndex ] |> class


placedClass =
    class "player-placed-card-area"


noTransition =
    attribute "no-transition" ""
