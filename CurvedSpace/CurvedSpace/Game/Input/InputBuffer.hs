module Game.Input.InputBuffer where

import qualified Game.Input.Input as I

type TimeInputs = [I.TimeInput]
data InputBuffer i = InputBuffer
                   { bufferInputs :: TimeInputs
                   , bufferItem :: i 
                   }

emptyImputs :: TimeInputs
emptyImputs = []

mkBuf :: i -> InputBuffer i
mkBuf = InputBuffer emptyImputs

addInput :: InputBuffer i -> I.TimeInput -> InputBuffer i
addInput buf@(InputBuffer inputs _) input =
    buf { bufferInputs = input : inputs }