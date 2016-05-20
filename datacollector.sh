#!/bin/bash

declare -a arrLevelH=("2" "3" "4" "5" "6" "7" "8");
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrTol=("5" "6" "7" "8");
declare -a memtypeArray=("main" "cuda");
declare -a memtypeArray2=("1" "2");
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
            for mem in "${memtypeArray2[@]}"
            do
                ./collector $lvlH $lvlL $miter $tol $mem
            done
        done
    done
    done
echo "done with collecting for level $lvlH..."
done
echo "ready! data can be found in level_X.data, choose wisely young padawan :"
ls | grep "level_"