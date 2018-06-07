module Explanation.Naive exposing (..)

import Card exposing (Card(..))
import Explanation.Model as Model
import Explanation.View as View
import Explanation.Update as Update
import Html
import Task
import Process


main =
    Html.program
        { init = Model.initialNoSeed [ OneOfScissors, TwoOfScissors, ThreeOfScissors, FourOfScissors, FiveOfScissors ]
        , view = View.view
        , update = Update.naiveUpdate
        , subscriptions = \_ -> Sub.none
        }
