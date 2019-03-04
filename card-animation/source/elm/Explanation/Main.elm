module Explanation.Main exposing (..)

import Card exposing (Card(..))
import Explanation.Model as Model
import Explanation.View as View
import Explanation.Update as Update
import Html
import Task
import Process


main =
    Html.programWithFlags
        { init = Model.initial [ AceOfPaper, KingOfScissors, TenOfRock, QueenOfPaper, JackOfRock, JokerOfScissors ]
        , view = View.view
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }
