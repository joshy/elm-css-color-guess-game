import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import String
import Random.Array exposing (shuffle)

port random : Int

type Action = NoOp | GuessColor String | NewGame Int | DefaultNewGame

type alias GameSize = Int
gameSize = 80


type alias Model =
  { colors : List String
  , randomColor : (Random.Seed, String)
  , correctGuesses : Int
  , wrongGuesses : Int
  , wrongColor : String
  }


initialModel : Model
initialModel =
 let
   colors = filterColors allColors 40 random
 in
   { colors = colors
   , randomColor = nextRandomColor colors (Random.initialSeed random)
   , correctGuesses = 0
   , wrongGuesses = 0
   , wrongColor = ""
   }


filterColors : List String -> Int -> Int -> List String
filterColors colors gameSize randomInt =
  let
    colorArray = Array.fromList allColors
    shuffled = shuffle colorArray
    seed = Random.initialSeed randomInt
    listShuffled = Array.toList (fst <| Random.generate shuffled seed)
    listValues = List.take gameSize listShuffled
  in
    listValues


update : Action -> Model -> Model
update action model =
  case action of
    NoOp
      -> model
    DefaultNewGame
      -> { model | colors = filterColors allColors (List.length model.colors) random
                 , randomColor = nextRandomColor model.colors (fst model.randomColor)
                 , correctGuesses = 0
                 , wrongGuesses = 0
                 , wrongColor = "" }
    NewGame gameSize
      -> { model | colors = filterColors allColors gameSize random
                 , randomColor = nextRandomColor model.colors (fst model.randomColor)
                 , correctGuesses = 0
                 , wrongGuesses = 0
                 , wrongColor = "" }
    GuessColor color
      ->
        if color == snd model.randomColor then
          { model | randomColor = nextRandomColor model.colors (fst model.randomColor)
                  , correctGuesses = model.correctGuesses + 1
                  , wrongColor = "" }
        else
          { model | wrongGuesses = model.wrongGuesses + 1
                  , wrongColor = color }


guessInbox : Signal.Mailbox Action
guessInbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  guessInbox.signal


nextRandomColor : List String -> Random.Seed -> (Random.Seed, String)
nextRandomColor colors = nextRandom colors


nextRandom : List String -> Random.Seed -> (Random.Seed, String)
nextRandom colors seed =
  let
    r = Random.generate (Random.int 0 (List.length colors - 1)) seed
    array = Array.fromList colors
    result = Maybe.withDefault "" (Array.get (fst r) array)
  in
    (snd r, result)


upperView : Model -> Html
upperView model =
    div [ class "upperView" ]
        [ p [ ] [ text "Click color "
                , span [ class "randomColorStyle" ] [ text (snd model.randomColor) ]
                , text "  "
                , span [ ] [ span [ ] [ text (toString model.correctGuesses)
                                      , text " / "
                                      ]
                          , span [ ] [ span [ ] [ text (toString model.wrongGuesses) ] ]
                          ]
                , a [ href "#"
                    , onClick guessInbox.address DefaultNewGame
                    , class "newGame"
                    ]
                    [ text "New Game" ]
                , if (String.length model.wrongColor > 0) then
                    p [ ] [ text "No, was "
                          , span [ style [ ("font-style", "italic") ] ]
                                 [ text model.wrongColor ]
                          , newGameSection
                          ]
                  else
                    p [ ] [ newGameSection]
                ]
        ]


newGameSection : Html
newGameSection =
    span [ style [("float", "right")] ]
         [ text "Colors: "
         , span [ class "gameSize" ]
                [ a [ href "#"
                    , onClick guessInbox.address (NewGame 40)
                    ]
                    [ text " 40 " ]
                , a [ href "#"
                    , onClick guessInbox.address (NewGame 80)
                    ]
                    [ text " 80 " ]
                , a [ href "#"
                    , onClick guessInbox.address (NewGame 120)
                    ]
                    [ text " 120 " ]
                , a [ href "#"
                    , onClick guessInbox.address (NewGame (List.length allColors))
                    ]
                    [ text " All " ]
                ]
         ]


singleColorView : String -> Html
singleColorView color =
  li [ ] [ a
           [ href "#"
           , onClick guessInbox.address (GuessColor color)
           , style [ colorStyle color ]
           , class "colorStyle"
           ]
           [ text " " ]
         ]


view :  Signal.Address Action -> Model ->  Html
view act model =
  div [ id "mainDiv" ]
    [ upperView model
    , ul [ ]
        (List.map singleColorView model.colors)
    , div [ ] [ text "Build by "
              , a [ href "https://twitter.com/irrwitz"
                  , class "button"
                  , target "_blank"
                  ]
                  [ text "@irrwitz" ]
              , text " Source on "
              , a [ href "https://github.com/irrwitz/elm-css-color-guess-game"
                  , class "button"
                  , target "_blank"
                  ]
                  [ text "Github"]
              ]
    ]


colorStyle color = ("background-color", color)


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view guessInbox.address) model


allColors : List String
allColors =
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