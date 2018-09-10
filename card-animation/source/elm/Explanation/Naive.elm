module Explanation.Naive exposing (main)

import Browser
import Card exposing (Card(..))
import Explanation.Model as Model
import Explanation.Update as Update
import Explanation.View as View


main =
    Browser.element
        { init = Model.initialNoSeed [ OneOfScissors, TwoOfScissors, ThreeOfScissors, FourOfScissors, FiveOfScissors ]
        , view = View.view
        , update = Update.naiveUpdate
        , subscriptions = \_ -> Sub.none
        }
