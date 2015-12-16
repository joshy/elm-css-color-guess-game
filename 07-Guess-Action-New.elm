import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)


type alias Model =
  { randomColor : (Random.Seed, String)
  , correctGuesses : Int
  , wrongGuesses : Int
  }


initialModel : Model
initialModel = 
  { randomColor = nextRandom (Random.initialSeed 0) colors 
  , correctGuesses = 0
  , wrongGuesses = 0
  }


type Action = NoOp | Guess String 


update : Action -> Model -> Model
update action model = 
  case action of
    NoOp 
      -> model
    Guess color
      ->
        if color == snd model.randomColor then
          { model | randomColor = nextRandom (fst model.randomColor) colors
                  , correctGuesses = model.correctGuesses + 1 }
        else
          { model | wrongGuesses = model.wrongGuesses + 1}


guessInbox : Signal.Mailbox Action
guessInbox =
  Signal.mailbox (Guess "")


actions : Signal Action
actions =
  guessInbox.signal 


colors : List String
colors =
   [ "AliceBlue"
   , "AntiqueWhite"
   , "Aqua"
   , "Aquamarine" 
   ]


nextRandom : Random.Seed -> List String -> (Random.Seed, String)
nextRandom seed colors =
  let
    r = Random.generate (Random.int 0 (List.length colors - 1)) seed
    array = Array.fromList colors
    result = Maybe.withDefault "" (Array.get (fst r) array)
  in 
    (snd r, result)  


randomColor : List String -> String
randomColor colors = 
  let 
    seed = Random.initialSeed 0
    tuple = Random.generate (Random.int 0 (List.length colors - 1)) seed
    array = Array.fromList colors
    result = Array.get (fst tuple) array
  in 
    Maybe.withDefault "" result


upperView : String -> Html
upperView colorToFind =
  div [ ]
    [ p [ style [("padding", "20px") ] ]
        [ text ("Click color: " ++ colorToFind) ]
    ]


singleColorView : String -> Html
singleColorView color =
  a 
    [ href "#"
    , onClick guessInbox.address (Guess color)
    , style [ ( "background", color ), ("padding", "20px") ]
    ]
    [ text " " ]


view :  Signal.Address Action -> Model ->  Html
view act model =
  div [ ]
    [ upperView <| snd model.randomColor
    , ul [ ] 
        (List.map singleColorView colors)
    , text ("Right guess " ++ toString model.correctGuesses)
    , text ("Wrong guess " ++ toString model.wrongGuesses)
    ]


model : Signal Model
model = 
  Signal.foldp update initialModel actions


main : Signal Html
main = 
  Signal.map (view guessInbox.address) model  
