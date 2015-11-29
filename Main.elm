import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Random.Array exposing (shuffle)
import Json.Decode as Json

main = Signal.map (view actions.address) model

seed = Random.initialSeed 48

randomized : List String
randomized = Array.toList <| fst <| shuffle seed <| Array.fromList cols

type alias Model = 
  { rightGuesses : Int
  , wrongGuesses : Int
  }
  
  
emptyModel : Model
emptyModel = 
  { rightGuesses = 0
  , wrongGuesses = 0
  }
  
  -- manage the model of our application over time
model : Signal Model
model =
  Signal.foldp update emptyModel actions.signal
  
  
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model
      CheckGuess data -> model  
      
type Action 
  = CheckGuess String
  | NoOp

actions : Signal.Mailbox Action 
actions =
  Signal.mailbox NoOp


view address model =
  ul []
    (List.map singleLink randomized)

singleLink : String -> Html
singleLink c =
  li []
    [ a 
        [ href "#"
        , onClick address Check
        , attribute "data-color" c
        , style [("background", c)]
        ] 
        []
    ]


cols : List String
cols =
   ["AliceBlue"
   ,"AntiqueWhite"
   ,"Aqua"
   ,"Aquamarine"
   ,"Azure"
   ,"Beige"
   ,"Bisque"
   ,"Black"
   ,"BlanchedAlmond"
   ,"Blue"
   ,"BlueViolet"
   ,"Brown"
   ,"BurlyWood"
   ,"CadetBlue"
   ,"Chartreuse"
   ,"Chocolate"
   ,"Coral"
   ,"CornflowerBlue"
   ,"Cornsilk"
   ,"Crimson"
   ,"Cyan"
   ,"DarkBlue"
   ,"DarkCyan"
   ,"DarkGoldenRod"
   ,"DarkGray"
   ,"DarkGreen"
   ,"DarkKhaki"
   ,"DarkMagenta"
   ,"DarkOliveGreen"
   ,"DarkOrange"
   ,"DarkOrchid"
   ,"DarkRed"
   ,"DarkSalmon"
   ,"DarkSeaGreen"
   ,"DarkSlateBlue"
   ,"DarkSlateGray"
   ,"DarkTurquoise"
   ,"DarkViolet"
   ,"DeepPink"
   ,"DeepSkyBlue"
   ,"DimGray"
   ,"DodgerBlue"
   ,"FireBrick"
   ,"FloralWhite"
   ,"ForestGreen"
   ,"Fuchsia"
   ,"Gainsboro"
   ,"GhostWhite"
   ,"Gold"
   ,"GoldenRod"
   ,"Gray"
   ,"Green"
   ,"GreenYellow"
   ,"HoneyDew"
   ,"HotPink"
   ,"IndianRed "
   ,"Indigo  "
   ,"Ivory"
   ,"Khaki"
   ,"Lavender"
   ,"LavenderBlush"
   ,"LawnGreen"
   ,"LemonChiffon"
   ,"LightBlue"
   ,"LightCoral"
   ,"LightCyan"
   ,"LightGoldenRodYellow"
   ,"LightGray"
   ,"LightGreen"
   ,"LightPink"
   ,"LightSalmon"
   ,"LightSeaGreen"
   ,"LightSkyBlue"
   ,"LightSlateGray"
   ,"LightSteelBlue"
   ,"LightYellow"
   ,"Lime"
   ,"LimeGreen"
   ,"Linen"
   ,"Magenta"
   ,"Maroon"
   ,"MediumAquaMarine"
   ,"MediumBlue"
   ,"MediumOrchid"
   ,"MediumPurple"
   ,"MediumSeaGreen"
   ,"MediumSlateBlue"
   ,"MediumSpringGreen"
   ,"MediumTurquoise"
   ,"MediumVioletRed"
   ,"MidnightBlue"
   ,"MintCream"
   ,"MistyRose"
   ,"Moccasin"
   ,"NavajoWhite"
   ,"Navy"
   ,"OldLace"
   ,"Olive"
   ,"OliveDrab"
   ,"Orange"
   ,"OrangeRed"
   ,"Orchid"
   ,"PaleGoldenRod"
   ,"PaleGreen"
   ,"PaleTurquoise"
   ,"PaleVioletRed"
   ,"PapayaWhip"
   ,"PeachPuff"
   ,"Peru"
   ,"Pink"
   ,"Plum"
   ,"PowderBlue"
   ,"Purple"
   ,"RebeccaPurple"
   ,"Red"
   ,"RosyBrown"
   ,"RoyalBlue"
   ,"SaddleBrown"
   ,"Salmon"
   ,"SandyBrown"
   ,"SeaGreen"
   ,"SeaShell"
   ,"Sienna"
   ,"Silver"
   ,"SkyBlue"
   ,"SlateBlue"
   ,"SlateGray"
   ,"Snow"
   ,"SpringGreen"
   ,"SteelBlue"
   ,"Tan"
   ,"Teal"
   ,"Thistle"
   ,"Tomato"
   ,"Turquoise"
   ,"Violet"
   ,"Wheat"
   ,"White"
   ,"WhiteSmoke"
   ,"Yellow"
   ,"YellowGreen"
   ]



