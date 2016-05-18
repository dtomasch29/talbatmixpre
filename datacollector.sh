#!/bin/bash

declare -a arrLevelH=("4" "5" "6" )
declare -a arrLevelL=("1" "2")
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrTol=("5" "6" "7" "8")
## now loop through the above array
for lvlH in "${arrLevelH[@]}"
do
echo "create file for level $lvlH ..."
touch level_$lvlH.data
    for lvlL in "${arrLevelL[@]}"
    do
    for miter in "${arrMaxIters[@]}"
    do
        for tol in "${arrTol[@]}"
        do
          ./collector $lvlH $lvlL $miter $tol
        done
    done
    done
echo "done with collecting for level $lvlH..."
done
echo "ready! data can be found in level_X.data, choose wisely young padawan :"
ls | grep "level_"