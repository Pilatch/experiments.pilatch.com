module Explanation.Main exposing (..)

import Browser
import Card exposing (Card(..))
import Explanation.Model as Model
import Explanation.Update as Update
import Explanation.View as View


main =
    Browser.element
        { init = Model.initial [ AceOfPaper, KingOfScissors, TenOfRock, QueenOfPaper, JackOfRock, JokerOfScissors ]
        , view = View.view
        , update = Update.update
        , subscriptions = always Sub.none
        }
