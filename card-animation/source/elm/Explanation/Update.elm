module Explanation.Update exposing (update)

import Explanation.Model exposing (..)
import List.Extra
import Process
import Random
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaceCard handIndex ->
            case List.Extra.getAt handIndex model.hand.cards of
                Nothing ->
                    ( model, Cmd.none )

                Just cardToPlace ->
                    let
                        newHand =
                            { animation = PlaceHandCard handIndex
                            , cards = model.hand.cards
                            }

                        newPlaced =
                            case model.placed.maybeCard of
                                Nothing ->
                                    { animation = NoPlacedAnimation
                                    , maybeCard = Nothing
                                    }

                                Just _ ->
                                    { animation = ReturnPlacedCardToHand
                                    , maybeCard = model.placed.maybeCard
                                    }

                        newModel =
                            { model | hand = newHand, placed = newPlaced }

                        command =
                            nextMsg 1250 <| Rearrange cardToPlace model.placed.maybeCard handIndex
                    in
                    ( newModel, command )

        Rearrange cardFromHand returnedPlacedCard placedHandIndex ->
            let
                newPlaced =
                    { animation = DuplicateAtPlaced cardFromHand
                    , maybeCard = Just cardFromHand
                    }

                handCardsWithoutPlaced =
                    List.Extra.removeAt placedHandIndex model.hand.cards

                newHandCards =
                    case returnedPlacedCard of
                        Nothing ->
                            handCardsWithoutPlaced

                        Just returnedCard ->
                            handCardsWithoutPlaced ++ [ returnedCard ]

                newHand =
                    { animation = NoHandAnimation
                    , cards = newHandCards
                    }
            in
            ( { model | placed = newPlaced, hand = newHand }, Cmd.none )


nextMsg : Float -> Msg -> Cmd Msg
nextMsg delay msg =
    Task.perform
        (always msg)
        (Process.sleep delay)



{-
   Msg - PlaceCard
   Add "placed" class to card at hand index. Shift other cards to left. If there's a placed card, add the hand-at-index class to it.
       Needs to know: hand-index of placed card, and number of cards in hand

   Msg - Rearrange
   Keep the hand as-is (like PlaceCard) and no-transition duplicate the placed card at the placed area.
   If a card was coming from placed, that needs to be duplicated at the hand too.
       Needs to know: same as above, but also Maybe Card from placed

-}
