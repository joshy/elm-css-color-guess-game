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
   ["AliceBlue"
   ,"AntiqueWhite"
   ,"Aqua"
   ,"Aquamarine" 
   ]


singleColorView : String -> Html
singleColorView color =
  a 
    [ href ("#" ++ color)
    , onClick inbox.address color
    , attribute "data-color" color
    , style [ ( "background", color ), ("padding", "20px") ]
    ]
    [ text " " ]


view : String -> String -> String -> Html
view color name colorMessage =
  div [ ]
    [ ul [ ] 
        (List.map singleColorView colors)
    , text ("Color choosen was:  " ++ colorMessage)
    ]


main : Signal Html
main = 
  Signal.map (view "steelblue" "foo") colorMessage  
