import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import String


port random : Int


type alias Model =
  { randomColor : (Random.Seed, String)
  , correctGuesses : Int
  , wrongGuesses : Int
  , wrongColor : String
  }


initialModel : Model
initialModel =
  { randomColor = nextRandomColor (Random.initialSeed random)
  , correctGuesses = 0
  , wrongGuesses = 0
  , wrongColor = ""
  }


type Action = NoOp | Guess String | NewGame


update : Action -> Model -> Model
update action model =
  case action of
    NoOp
      -> model
    NewGame
      -> { model | randomColor = nextRandomColor (fst model.randomColor)
                  , correctGuesses = 0
                  , wrongGuesses = 0
                  , wrongColor = "" }
    Guess color
      ->
        if color == snd model.randomColor then
          { model | randomColor = nextRandomColor (fst model.randomColor)
                  , correctGuesses = model.correctGuesses + 1
                  , wrongColor = "" }
        else
          { model | wrongGuesses = model.wrongGuesses + 1
                  , wrongColor = color }


guessInbox : Signal.Mailbox Action
guessInbox =
  Signal.mailbox (Guess "")


actions : Signal Action
actions =
  guessInbox.signal


nextRandomColor : Random.Seed -> ( Random.Seed, String )
nextRandomColor = nextRandom colors


nextRandom : List String -> Random.Seed -> (Random.Seed, String)
nextRandom colors seed =
  let
    r = Random.generate (Random.int 0 (List.length colors - 1)) seed
    array = Array.fromList colors
    result = Maybe.withDefault "" (Array.get (fst r) array)
  in
    (snd r, result)


(=>) : a -> b -> ( a, b )
(=>) = (,)


upperView : Model -> Html
upperView model =
    p [ class "upperView" ]
        [ text "Click the color "
        , span [ class "randomColorStyle" ] [ text (snd model.randomColor) ]
        , text "  "
        , span [ ] [ span [ ] [ text (toString model.correctGuesses)
                              , text " / "
                              ]
                   , span [ ] [ span [ ] [ text (toString model.wrongGuesses) ] ]
                   ]
        , a [ href "#"
            , onClick guessInbox.address NewGame
            , class "newGame"
            ]
            [ text "New Game" ]
        , if (String.length model.wrongColor > 0) then
            p [ ] [ text "Wrong, color was "
                  , span [ style [ "font-style" => "italic" ] ] [ text model.wrongColor ]
                  ]
          else
            div [ ] [ ]
        ]


singleColorView : String -> Html
singleColorView color =
  li [ ] [ a
           [ href "#"
           , onClick guessInbox.address (Guess color)
           , style (colorStyle color)
           , class "colorStyle"
           ]
           [ text " " ]
         ]


view :  Signal.Address Action -> Model ->  Html
view act model =
  div [ id "mainDiv" ]
    [ upperView model
    , ul [ ]
        (List.map singleColorView colors)
    ]


colorStyle color = [ "background-color" => color ]


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view guessInbox.address) model


colors : List String
colors =
  [ "AliceBlue"
  , "AntiqueWhite"
  , "Aqua"
  , "Aquamarine"
  , "Azure"
  , "Beige"
  , "Bisque"
  , "Black"
  , "BlanchedAlmond"
  , "Blue"
  , "BlueViolet"
  , "Brown"
  , "BurlyWood"
  , "CadetBlue"
  , "Chartreuse"
  , "Chocolate"
  , "Coral"
  , "CornflowerBlue"
  , "Cornsilk"
  , "Crimson"
  , "Cyan"
  , "DarkBlue"
  , "DarkCyan"
  , "DarkGoldenRod"
  , "DarkGray"
  , "DarkGreen"
  , "DarkKhaki"
  , "DarkMagenta"
  , "DarkOliveGreen"
  , "DarkOrange"
  , "DarkOrchid"
  , "DarkRed"
  , "DarkSalmon"
  , "DarkSeaGreen"
  , "DarkSlateBlue"
  , "DarkSlateGray"
  , "DarkTurquoise"
  , "DarkViolet"
  , "DeepPink"
  , "DeepSkyBlue"
  , "DimGray"
  , "DodgerBlue"
  , "FireBrick"
  , "FloralWhite"
  , "ForestGreen"
  , "Fuchsia"
  , "Gainsboro"
  , "GhostWhite"
  , "Gold"
  , "GoldenRod"
  , "Gray"
  , "Green"
  , "GreenYellow"
  , "HoneyDew"
  , "HotPink"
  , "IndianRed "
  , "Indigo  "
  , "Ivory"
  , "Khaki"
  , "Lavender"
  , "LavenderBlush"
  , "LawnGreen"
  , "LemonChiffon"
  , "LightBlue"
  , "LightCoral"
  , "LightCyan"
  , "LightGoldenRodYellow"
  , "LightGray"
  , "LightGreen"
  , "LightPink"
  , "LightSalmon"
  , "LightSeaGreen"
  , "LightSkyBlue"
  , "LightSlateGray"
  , "LightSteelBlue"
  , "LightYellow"
  , "Lime"
  , "LimeGreen"
  , "Linen"
  , "Magenta"
  , "Maroon"
  , "MediumAquaMarine"
  , "MediumBlue"
  , "MediumOrchid"
  , "MediumPurple"
  , "MediumSeaGreen"
  , "MediumSlateBlue"
  , "MediumSpringGreen"
  , "MediumTurquoise"
  , "MediumVioletRed"
  , "MidnightBlue"
  , "MintCream"
  , "MistyRose"
  , "Moccasin"
  , "NavajoWhite"
  , "Navy"
  , "OldLace"
  , "Olive"
  , "OliveDrab"
  , "Orange"
  , "OrangeRed"
  , "Orchid"
  , "PaleGoldenRod"
  , "PaleGreen"
  , "PaleTurquoise"
  , "PaleVioletRed"
  , "PapayaWhip"
  , "PeachPuff"
  , "Peru"
  , "Pink"
  , "Plum"
  , "PowderBlue"
  , "Purple"
  , "RebeccaPurple"
  , "Red"
  , "RosyBrown"
  , "RoyalBlue"
  , "SaddleBrown"
  , "Salmon"
  , "SandyBrown"
  , "SeaGreen"
  , "SeaShell"
  , "Sienna"
  , "Silver"
  , "SkyBlue"
  , "SlateBlue"
  , "SlateGray"
  , "Snow"
  , "SpringGreen"
  , "SteelBlue"
  , "Tan"
  , "Teal"
  , "Thistle"
  , "Tomato"
  , "Turquoise"
  , "Violet"
  , "Wheat"
  , "White"
  , "WhiteSmoke"
  , "Yellow"
  , "YellowGreen"
   ]