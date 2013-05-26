module Game.Input.InputBuffer where

import qualified Game.Input.Input as I

type TimeInputs = [I.TimeInput]
data InputBuffer = InputBuffer
                   { bufferInputs :: TimeInputs 
                   }

emptyImputs :: TimeInputs
emptyImputs = []

emptyInputBuffer :: InputBuffer
emptyInputBuffer = InputBuffer emptyImputs

addInput :: InputBuffer -> I.TimeInput -> InputBuffer
addInput buf@(InputBuffer inputs) input =
    buf { bufferInputs = input : inputs }