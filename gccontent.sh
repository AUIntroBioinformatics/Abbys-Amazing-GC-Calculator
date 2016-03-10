#! /bin/sh

#Get the file name

echo "Calculating GC Content for $1 ..."

if [ $# != 1 ]; then
        echo "Please include a fasta input on the command line!"
        exit
fi


#Find header and put in array

IFS=$'\n'
Headers=($(grep ">" $1))
Sequences=($(grep -v ">" $1))

#Find all G's and C's in sequence array and store to another array

NL=${#Sequences[@]}
echo "Number of Sequences in File: $NL"
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

echo "GC Content for $1 ...  " > $1.gcoutput.txt
NX=${#Headers[@]}
let NX=$NX-1
N=0
H=0
while test $N -le $NX
do
	echo "*** " >> $1.gcoutput.txt
	echo ${Headers[$N]} >> $1.gcoutput.txt
	echo "${Percent[$H]} % GC CONTENT" >> $1.gcoutput.txt
	H=`expr $H + 1`
	N=`expr $N + 1`
done

cat $1.gcoutput.txt

