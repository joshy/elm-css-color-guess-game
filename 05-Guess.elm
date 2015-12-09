import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)


inbox : Signal.Mailbox String
inbox = 
  Signal.mailbox ""


colorMessage : Signal String
colorMessage = 
  inbox.signal  


colors : List String
colors =
   [ "AliceBlue"
   , "AntiqueWhite"
   , "Aqua"
   , "Aquamarine" 
   ]

randomColor : List String -> String
randomColor colors = 
  let 
    seed = Random.initialSeed 31315
    tuple = Random.generate (Random.int 0 (List.length colors - 1)) seed
    array = Array.fromList colors
    result = Array.get (fst tuple) array
  in 
    Maybe.withDefault "" result


upperView : String -> Html
upperView colorToFind =
  div [ ]
    [ p [ ]
        [ text ("Click color: " ++ colorToFind) ]
    ]


singleColorView : String -> Html
singleColorView color =
  a 
    [ href "#"
    , onClick inbox.address color
    , attribute "data-color" color
    , style [ ( "background", color ), ("padding", "20px") ]
    ]
    [ text " " ]


view :  String -> Html
view  colorMessage =
  div [ ]
    [ upperView <| randomColor colors
    , ul [ ] 
        (List.map singleColorView colors)
    , text ("Color choosen was:  " ++ colorMessage)
    ]


main : Signal Html
main = 
  Signal.map view colorMessage  
