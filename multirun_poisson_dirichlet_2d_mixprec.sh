#!/bin/bash
declare -a arrLevelH=("2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7");
declare -a arrTol=("5" "6" "7" "8");
declare -a memtypeArray=("main" "cuda");
## now loop through the above array

echo "Starting mixprec tests"
for lvlH in "${arrLevelH[@]}"
do
  lvlL=$((1));
  while [ $lvlL -lt $lvlH ]
  do
   for miter in "${arrMaxIters[@]}"
    do
       for tol in "${arrTol[@]}"
       do
         for memtype in "${memtypeArray[@]}"
         do
             ./poisson_dirichlet_2d_mixprec --meshfile ../data/meshes/unit-square-quad.xml --mem $memtype --logto output.data --statistics --level $lvlH $lvlL --maxiter $miter --deftol 1E-$tol > output.log
             fldr=lvl$lvlH-$lvlL-miter$miter-tol$tol-mem$memtype-mixprec
             echo "creating folder $fldr"
             mkdir -p $fldr
             #mv *.vtu $fldr
             #mv *.pvtu $fldr
             mv *.data $fldr
             mv *.log $fldr

             cat $fldr/output.log | grep 'H0-Error' >> $fldr/output.data
            cat $fldr/output.log | grep 'H1-Error' >> $fldr/output.data
             echo "memtype: $memtype" >> $fldr/output.data
            echo "prec: mixprec" >> $fldr/output.data
        done
       done
    done
  lvlL=$(($lvlL+1));
  done
done
echo "Mixprec tests done"
echo "Starting singleprec tests"
for lvlH in "${arrLevelH[@]}"
do

  lvlL=$((1));
  while [ $lvlL -lt $lvlH ]
  do

    for memtype in "${memtypeArray[@]}"
    do

         echo "Testlauf: LvlH: $lvlH LvlL: $lvlL Memtype: $memtype Prectype: singleprec";
         ./poisson_dirichlet_2d --meshfile ../data/meshes/unit-square-quad.xml --mem $memtype --statistics --level $lvlH $lvlL > output.log
         #foulderName = "$lvlH_$lvlL_miter$miter_tol$tol"
         fldr=lvl$lvlH-$lvlL-mem$memtype-precsingle
         echo "creating folder $fldr";
         mkdir -p $fldr
         #mv *.vtu $fldr
         #mv *.pvtu $fldr
         #mv *.data $fldr
         mv *.log $fldr
         touch $fldr/output.data
         rm $fldr/output.data
         touch $fldr/output.data
         echo "Level-Grob:$lvlH" >> $fldr/output.data
         echo "Level-Fine:$lvlL" >> $fldr/output.data
         cat $fldr/output.log | grep 'Total time:' >>$fldr/output.data
         cat $fldr/output.log | grep 'H0-Error' >> $fldr/output.data
         cat $fldr/output.log | grep 'H1-Error' >> $fldr/output.data
         echo "memtype: $memtype" >> $fldr/output.data
         echo "prec: singleprec" >> $fldr/output.data
    done
    lvlL=$(($lvlL+1));
  done
done
mail -s "Multirun ist fertig auf arryn" daniel.tomaschewski@tu-dortmund.de,christoph.hoeppke@gmail.com <<< 'dies ist eine automatische mail am ende vom bash script, maxiter war nur bis 7, lvlH bis 10'

# You can access them using echo "${arr[0]}", "${arr[1]}" also
