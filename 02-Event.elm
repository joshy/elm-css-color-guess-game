import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)


main : Signal Html
main = 
  Signal.map (view "steelblue" "foo") colorMessage  


inbox : Signal.Mailbox String
inbox = 
  Signal.mailbox "Initial status ..."
  
colorMessage : Signal String
colorMessage = 
  inbox.signal  

view : String -> String -> String -> Html
view color name colorMessage =
  div [ ]
    [ a 
      [ href ("#" ++ color)
      , onClick inbox.address color
      , attribute "data-color" color
      , style [( "background", color )]
      ] 
      [text color]
      , text ("  --->  " ++ colorMessage)
    ]
