import Html exposing (text)
import Random
import Array
import Maybe
import Date

list : List String
list = ["asf", "adfa", "asdfaf", "asdfaf"]

pickOne : List String -> String
pickOne list = 
  let 
    seed0 = Random.initialSeed 3123415
    tuple = Random.generate (Random.int 0 (List.length list - 1)) seed0
    array = Array.fromList list
    result = Array.get (fst tuple) array
  in 
    Maybe.withDefault "NOOOOO" result

main =
  text (pickOne list)