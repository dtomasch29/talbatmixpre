#!/bin/bash
declare -a arrLevelH=("2" "3" "4" "5" "6" "7" "8");
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrTol=("5" "6" "7" "8");
declare -a memtypeArray=("main" "cuda");
declare -a compArray=("time" "h0err" "h1err");
## now loop through the above array

echo "create file for level $lvlH ..."
lvlL=$((1));
for miter in "${arrMaxIters[@]}"
do
    for tol in "${arrTol[@]}"
    do
        for mem in "${memtypeArray[@]}"
        do
            fileout=arryn-maxiters$miter-tol$tol-memtype$mem-mixprec.data;
            touch $fileout;
            echo "output file: $fileout";
            echo "n time h0err h1err" > $fileout
            for lvlH in "${arrLevelH[@]}"
            do
                fldr=lvl$lvlH-1-miter$miter-tol$tol-mem$mem-mixprec;
                time=$(cat $fldr/output.data | grep 'Total time:' | cut -d " " -f 3)
                time=$(printf "%1.16f\n" $time)
                h0error=$(cat $fldr/output.data | grep 'H0-Error:' | cut -d " " -f 2)
                h0error=$(printf "%1.16f\n" $h0error)
                h1error=$(cat $fldr/output.data | grep 'H1-Error:' | cut -d " " -f 2)
                h1error=$(printf "%1.16f\n" $h1error)
                n=$(bc <<< "2^$lvlH -1 " )
                #a=grep 'Total time:' $fldr/output.data
                #time=cut -d " " -f 2 <<< $a;
                
                #a=cat $fldr/output.data | grep ''
                #h0error=cut -d " " -f 2 <<< $a; 
                
                #a=cat $fldr/output.data | grep 'H1-Error:'
                #h1error=cut -d " " -f 2 <<< $a;
                #n=bc <<< "2^$lvlH";
                echo "$n $time $h0error $h1error" >> $fileout;
            done
        done
    done
done

for mem in "${memtypeArray[@]}"
do
    fileout=arryn-memtype$mem-singleprec.data;
    rm $fileout;
    touch $fileout;
    echo "output file: $fileout";
    echo " " > $fileout
    echo "n time h0err h1err" > $fileout
    for lvlH in "${arrLevelH[@]}"
    do
       fldr=lvl$lvlH-1-mem$mem-precsingle;
       echo $fldr
       time=$(cat $fldr/output.data | grep 'Total time:' | cut -d " " -f 3 | cut -d "s" -f 1)
       time=$(printf "%1.16f\n" $time)
       h0error=$(cat $fldr/output.data | grep 'H0-Error:' | cut -d " " -f 2)
       h0error=$(printf "%1.16f\n" $h0error)
       h1error=$(cat $fldr/output.data | grep 'H1-Error:' | cut -d " " -f 2)
       h1error=$(printf "%1.16f\n" $h1error)
       n=$(bc <<< "2^$lvlH -1 ")
                
       echo "$n $time $h0error $h1error" >> $fileout;
    done
done
echo "done creating files";

echo "creating LaTeX output";
ltxfile=output2.tex
fldr="."
touch $fldr/$ltxfile;
echo " " > $fldr/$ltxfile;
cat LaTeX/com1.txt >> $fldr/$ltxfile

#for tol in "${arrTol[@]}"
#do
#    for miter in "${arrMaxIters[@]}"
#    do
        tol=5
        miter=3
        #Arryn
        cat LaTeX/com3.txt >> $fldr/$ltxfile;
        for comp in "${compArray[@]}"
        do
            cat LaTeX/com2.txt >> $fldr/$ltxfile;
            echo "\addplot[solid,mark=triangle,mark size=2pt,chart1] table[x=n, y=$comp] {arryn-maxiters$miter-tol$tol-memtypecuda-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=square,mark size=2pt,chart2] table[x=n, y=$comp] {arryn-maxiters$miter-tol$tol-memtypemain-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=diamond,mark size=2pt,chart3] table[x=n, y=$comp] {arryn-memtypecuda-singleprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=otimes,mark size=2pt,chart4] table[x=n, y=$comp] {arryn-memtypemain-singleprec.data};" >> $fldr/$ltxfile
            
        done
        #JETSON
        for comp in "${compArray[@]}"
        do
            cat LaTeX/com2.txt >> $fldr/$ltxfile;
            echo "\addplot[solid,mark=triangle,mark size=2pt,chart1] table[x=n, y=$comp] {arryn-maxiters$miter-tol$tol-memtypecuda-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=square,mark size=2pt,chart2] table[x=n, y=$comp] {arryn-maxiters$miter-tol$tol-memtypemain-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=diamond,mark size=2pt,chart3] table[x=n, y=$comp] {arryn-memtypecuda-singleprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=otimes,mark size=2pt,chart4] table[x=n, y=$comp] {arryn-memtypemain-singleprec.data};" >> $fldr/$ltxfile
            
        done
        echo "\end{groupplot}" >>  $fldr/$ltxfile
#    done
#done
echo "\end{tikzpicture}" >>$fldr/$ltxfile
echo "\end{document}" >> $fldr/$ltxfile




