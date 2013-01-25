#!/bin/bash

cd CurvedSpace
ghc -threaded -outputdir ../bin -o ../bin/CurvedSpace CurvedSpace.hs
cd ..

./run-tests.sh
