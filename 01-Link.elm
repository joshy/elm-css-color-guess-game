import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)


main : Html
main = 
  view "foo" 

view : String -> Html
view  name =
  div [ ]
    [ a 
      [ href "#"
      , attribute "data-color" "steelblue"
      , style [("background", "steelblue")]
      ] 
      [text "steelblue"]
      , text ("  " ++ name)
    ]
