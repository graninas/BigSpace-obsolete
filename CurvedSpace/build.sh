#!/bin/bash

cd CurvedSpace
ghc -threaded --make -outputdir ../bin -o ../bin/CurvedSpace CurvedSpace.hs
cd ..

