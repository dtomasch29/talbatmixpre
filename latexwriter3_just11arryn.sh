#!/bin/bash
declare -a arrLevelH=("2" "3" "4" "5" "6" "7" "8" "9" "10" "11");
declare -a arrLevelL=("1" "2" "3" "4" );
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrTol=("5" "6" "7" "8");
declare -a arrDown=("4" "5" "6" "7" "8" "9" "10" );
declare -a onezero=("0");#
declare -a memtypeArray=("main" "cuda");
declare -a compArray=("time" "h0err" "h1err");
declare -a simulationFldrs=("arryn_data" "jetson_data");
declare -a dataFldrs=("arryn_d" "jetson_d");
declare -a computers=("arryn" "jetson");## now loop through the above array

mkdir -p arryn_d
mkdir -p jetson_d

for computer in "${onezero[@]}"
do
  for miter in "${arrMaxIters[@]}"
  do
    for tol in "${arrTol[@]}"
    do
        for mem in "${memtypeArray[@]}"
        do
            infldr="${simulationFldrs[computer]}"
            outfldr="${dataFldrs[computer]}"    
            fileout=$outfldr/just-maxiters$miter-tol$tol-memtype$mem-mixprec.data;
            touch $fileout;
            echo "output file: $fileout";
            echo "n time h0err h1err" > $fileout
            for lvlH in "${arrLevelH[@]}"
            do  
                
               fldr=$infldr/lvl$lvlH-1-miter$miter-tol$tol-mem$mem-mixprec;
                if [ $computer -eq 1 ]
                then
                  time=$(cat $fldr/output.data | grep 'Time:' | cut -c 7-)
                else
                  time=$(cat $fldr/output.data | grep 'Total time:' | cut -d " " -f 3)
                fi
                time=$(printf "%1.16f\n" $time)
                h0error=$(cat $fldr/output.data | grep 'H0-Error:' | cut -d " " -f 2)
                h0error=$(printf "%1.16f\n" $h0error)
                h1error=$(cat $fldr/output.data | grep 'H1-Error:' | cut -d " " -f 2)
                h1error=$(printf "%1.16f\n" $h1error)
                n=$(bc <<< "2^$lvlH -1 " )
                echo "$n $time $h0error $h1error" >> $fileout;
            done
        done
    done
  done
done

echo "collection singleprec data"
for computer in "${onezero[@]}"
do
for mem in "${memtypeArray[@]}"
do
    infldr="${simulationFldrs[computer]}"
    outfldr="${dataFldrs[computer]}"
    fileout=$outfldr/just-memtype$mem-singleprec.data;
    rm $fileout;
    touch $fileout;
    echo "output file: $fileout";
    echo " " > $fileout
    echo "n time h0err h1err" > $fileout
    for lvlH in "${arrLevelH[@]}"
    do
       fldr=$infldr/lvl$lvlH-1-mem$mem-precsingle;
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
done


echo "done creating files";
echo "creating LaTeX output";
echo "Make sure that arryn files are in subfolder applications/data-arryn"
echo "Make sure that jetson files are in subfolder applications/data-jetson"
name="output"
ltxfile=$name.tex
fldr="."
touch $fldr/$ltxfile;
dataArryn="${dataFldrs[0]}";
dataJetson="${dataFldrs[1]}";
for tol in "${arrTol[@]}"
do
    for miter in "${arrMaxIters[@]}"
    do
        echo "PDF-LaTeX call for  tol=$tol, miter=$miter"
        echo " " > $fldr/$ltxfile;
        cat LATEX/com1.txt >> $fldr/$ltxfile

        #Arryn
        for comp in "${compArray[@]}"
        do
            echo "\nextgroupplot[title=${computers[0]}," >> $fldr/$ltxfile;
                if [ $comp == "time" ]
                then
                   echo "ylabel={Runtime [s]}," >> $fldr/$ltxfile;
                   cat LATEX/com2.txt >> $fldr/$ltxfile;
                elif [ $comp == "h0err" ]
                then
                   echo "ylabel={H0-Error}," >> $fldr/$ltxfile;
                   cat LATEX/com2_2.txt >> $fldr/$ltxfile;
                else
                   echo "ylabel={H1-Error}," >> $fldr/$ltxfile;
                   cat LATEX/com2_2.txt >> $fldr/$ltxfile;
                fi
            echo "\addplot[solid,mark=triangle,mark size=2pt,chart1] table[x=n, y=$comp] {$dataArryn/just-maxiters$miter-tol$tol-memtypecuda-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=square,mark size=2pt,chart2] table[x=n, y=$comp] {$dataArryn/just-maxiters$miter-tol$tol-memtypemain-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=diamond,mark size=2pt,chart3] table[x=n, y=$comp] {$dataArryn/just-memtypecuda-singleprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=otimes,mark size=2pt,chart4] table[x=n, y=$comp] {$dataArryn/just-memtypemain-singleprec.data};" >> $fldr/$ltxfile
            
        done
        echo "\end{groupplot}" >>  $fldr/$ltxfile
        echo LATEX/com3.txt >> $fldr/$ltxfile
        echo "\end{tikzpicture}" >>$fldr/$ltxfile
        echo "\end{document}" >> $fldr/$ltxfile
        pdflatex $fldr/$ltxfile --shell-escape > /dev/null
        convert -density 300 -quality 100 $name.pdf justarryn11-plot-tol$tol-miter$miter.jpg
    done
done


