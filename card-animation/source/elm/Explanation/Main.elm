module Explanation.Main exposing (..)

import Explanation.Model as Model
import Explanation.View as View
import Explanation.Update as Update
import Html
import Task
import Process


main =
    Html.programWithFlags
        { init = Model.initial
        , view = View.view
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }
