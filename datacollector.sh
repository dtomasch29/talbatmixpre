#!/bin/bash
declare -a arrLevelH=("2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrMaxIters=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10");
declare -a arrTol=("5" "6" "7" "8");
declare -a onezero=("0" "1");
declare -a memtypeArray=("main" "cuda");
declare -a compArray=("time" "h0err" "h1err");
declare -a simulationFldrs=("arryn_data" "jetson_data");
declare -a dataFldrs=("arryn_d" "jetson_d");
declare -a computers=("arryn" "jetson");
declare -a components=("Runtime[s]" "H0-Error" "H1-Error");
declare -a legends=("Double-Float GPU" "Double Float CPU" "Double GPU" "Double CPU")
## now loop through the above array

mkdir -p arryn_d
mkdir -p jetson_d
echo "create file for level $lvlH ..."
lvlL=$((1));
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
            fileout=$outfldr/maxiters$miter-tol$tol-memtype$mem-mixprec.data;
            touch $fileout;
            echo "output file: $fileout";
            echo "n time h0err h1err" > $fileout
            for lvlH in "${arrLevelH[@]}"
            do
                fldr=$infldr/lvl$lvlH-1-miter$miter-tol$tol-mem$mem-mixprec;
                time=$(cat $fldr/output.data | grep 'Total time:' | cut -d " " -f 3)
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
    fileout=$outfldr/memtype$mem-singleprec.data;
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
        echo "PDF-LaTeX call for tol=$tol, miter=$miter"
        echo " " > $fldr/$ltxfile;
        cat LaTeX/com1.txt >> $fldr/$ltxfile
		start=$((1));
        counter=$((0));
        #Arryn
        cat LaTeX/com3.txt >> $fldr/$ltxfile;
        for comp in "${compArray[@]}"
        do
            echo "\nextgroupplot[title=${computers[0]}," >> $fldr/$ltxfile;
			if ($start -lt 2)
			then
				start=$((5));
		        cat LaTeX/com2-1.txt >> $fldr/$ltxfile;
				echo "ylabel={${components[counter]}}" >> $fldr/$ltxfile;
				cat LaTeX/com2-2.txt >> $fldr/$ltxfile;		
				counter=$counter+1;
			else
				cat LaTeX/com4-1.txt >> $fldr/$ltxfile;	
				echo "ylabel={${components[counter]}}" >> $fldr/$ltxfile;
				cat LaTeX/com4-2.txt >> $fldr/$ltxfile;		
				counter=$(($counter+1));			
			fi
            cat LaTeX/com2.txt >> $fldr/$ltxfile;
            echo "\addplot[solid,mark=triangle,mark size=2pt,chart1] table[x=n, y=$comp] {$dataArryn/maxiters$miter-tol$tol-memtypecuda-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=square,mark size=2pt,chart2] table[x=n, y=$comp] {$dataArryn/maxiters$miter-tol$tol-memtypemain-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=diamond,mark size=2pt,chart3] table[x=n, y=$comp] {$dataArryn/memtypecuda-singleprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=otimes,mark size=2pt,chart4] table[x=n, y=$comp] {$dataArryn/memtypemain-singleprec.data};" >> $fldr/$ltxfile
            
        done
		counter=$((0));
        #JETSON
        for comp in "${compArray[@]}"
        do
			echo "\nextgroupplot[title=${computers[1]}," >> $fldr/$ltxfile;			
			cat LaTeX/com4-1.txt >> $fldr/$ltxfile;	
			echo "ylabel={${components[counter]}}" >> $fldr/$ltxfile;
			cat LaTeX/com4-2.txt >> $fldr/$ltxfile;		
			counter=$(($counter+1));
            #
            cat LaTeX/com2.txt >> $fldr/$ltxfile;
            echo "\addplot[solid,mark=triangle,mark size=2pt,chart1] table[x=n, y=$comp] {$dataJetson/maxiters$miter-tol$tol-memtypecuda-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=square,mark size=2pt,chart2] table[x=n, y=$comp] {$dataJetson/maxiters$miter-tol$tol-memtypemain-mixprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=diamond,mark size=2pt,chart3] table[x=n, y=$comp] {$dataJetson/memtypecuda-singleprec.data};" >> $fldr/$ltxfile
            echo "\addplot[solid,mark=otimes,mark size=2pt,chart4] table[x=n, y=$comp] {$dataJetson/memtypemain-singleprec.data};" >> $fldr/$ltxfile
            
        done
        echo "\end{groupplot}" >>  $fldr/$ltxfile
        echo "\end{tikzpicture}" >>$fldr/$ltxfile
        echo "\end{document}" >> $fldr/$ltxfile
        pdflatex $fldr/$ltxfile > /dev/null
        mv $name.pdf plot-tol$tol-miter$miter.pdf
    done
done



