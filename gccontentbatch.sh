#! /bin/sh

#Prepare to batch

echo "Calculating GC Content..."

if [ $# -le 1 ]; then
        echo "Please include more than one fasta input on the command line for batch processing! If you are interested in processing a single fasta file and viewing the GC content immediately, 
please use the script 'gccontent.sh' ."
        exit
fi

for FILE in $*
do

	#Find header and put in array
	IFS=$'\n'
	Headers=($(grep ">" $FILE))
	Sequences=($(grep -v ">" $FILE))

	#Find all G's and C's in sequence array and store to another array
	NL=${#Sequences[@]}
	echo "Number of Sequences in $FILE: $NL"
	let NL=$NL-1
	let X=0
	while test $X -le $NL
	do
		TOT=`echo ${Sequences[$X]} | wc -m`
		TOTFIX=`expr $TOT - 1`
		G=`echo ${Sequences[$X]} | grep -roi "g" | wc -m`
		C=`echo ${Sequences[$X]} | grep -roi "c" | wc -m`
		GC=`expr $G + $C`
		GCBIIG=`expr $GC \* 50`
		Percent[$X]=`expr $GCBIIG / $TOTFIX` 
		let X=$X+1
	done 

	#Append to a txt output
	echo "GC Content for $FILE ...  " > $FILE.gcoutput.txt
	NX=${#Headers[@]}
	let NX=$NX-1
	N=0
	H=0
	while test $N -le $NX
	do
		echo "*** " >> $FILE.gcoutput.txt
		echo ${Headers[$N]} >> $FILE.gcoutput.txt
		echo "${Percent[$H]} % GC CONTENT" >> $FILE.gcoutput.txt
		H=`expr $H + 1`
		N=`expr $N + 1`
	done

done
