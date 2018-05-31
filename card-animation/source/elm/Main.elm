module Main exposing (..)

import Model as Model
import View as View
import Update as Update
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
